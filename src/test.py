import os

from nadeo_api import auth, live


def main() -> None:
    token: auth.Token = auth.get_token(
        'live',
        os.environ['TM_E416DEV_SERVER_USERNAME'],
        os.environ['TM_E416DEV_SERVER_PASSWORD'],
        os.environ['TM_E416DEV_AGENT'],
        True
    )

    clubId: int = 67469
    # length: int = 5
    # offset: int = 0

    # req: dict = live.get(
    #     token,
    #     f'api/token/club/{clubId}/member?length={length}&offset={offset}'
    # )

    # import re
    # input: str = r'C:\Users\Ezio/OpenplanetNext/PluginStorage/ClubManager/icons/https___trackmania-prod-media-s3.cdn.ubi.com_media_image_live-api_1f037bee-8fab-435c-b397-b6f7a44f2da7_png_small.png_timestamp=1705448703.png'
    # # input: str = r'1f037bee-8fab-435c-b397-b6f7a44f2da7'
    # matches = re.match(r'[0-9a-fA-F]{8}', input)
    # pattern = re.compile("[0-9a-fA-F]{8}")

    campaignId: int = 77249

    req: dict = live.get(
        token,
        f'api/token/club/{clubId}/campaign/{campaignId}'
    )

    pass


if __name__ == '__main__':
    main()
