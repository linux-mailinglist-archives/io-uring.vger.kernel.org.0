Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE5950FCC9
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 14:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbiDZMVZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 08:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349930AbiDZMVQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 08:21:16 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7412C66D
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:16:56 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220426121654epoutp04edacfbe579898adfc49993bb46edc58c~pcWRjktSl2403224032epoutp04A
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 12:16:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220426121654epoutp04edacfbe579898adfc49993bb46edc58c~pcWRjktSl2403224032epoutp04A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1650975414;
        bh=zH98b48edWAcbuGFMqRYxjx1SKH0zljZEL+gYb87BsE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pQ9K2949QiNSG8WUuoB6j41DHPwhU6cxOOz2utgWGiJy1gaJOkc/0BvtXkTjb2J38
         tDV2HPJ3wDnt0iGvpJTcGD/+lb7B4XFwjAbxhXoN8PO/cCWVVl9gbZP7umn5qOiAVS
         r6E4iutIKzX/T7GtpwaZxs1rJwphZxplakxIhDuY=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220426121654epcas5p2fa05885afa9281e4510dffd11f78256a~pcWRW7EOa2624626246epcas5p2P;
        Tue, 26 Apr 2022 12:16:54 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Kngq74rnsz4x9Pv; Tue, 26 Apr
        2022 12:16:51 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.8F.09827.2B2E7626; Tue, 26 Apr 2022 21:16:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220426114249epcas5p238c9b454b6131672830beb8e44c6d721~pb4hT5ZDJ2078820788epcas5p24;
        Tue, 26 Apr 2022 11:42:49 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220426114249epsmtrp13cc1aa19ab1ae2316d2b50297eaa6be4~pb4hTUs4E0719507195epsmtrp1y;
        Tue, 26 Apr 2022 11:42:49 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-3d-6267e2b2eecc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.AF.08924.9BAD7626; Tue, 26 Apr 2022 20:42:49 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220426114248epsmtip2415b2b81438eb9ecc949162cc589f4f8~pb4gaTL0p1469814698epsmtip2I;
        Tue, 26 Apr 2022 11:42:48 +0000 (GMT)
Date:   Tue, 26 Apr 2022 17:07:41 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 00/12] add large CQE support for io-uring
Message-ID: <20220426113741.GA22115@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220425182530.2442911-1-shr@fb.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdlhTQ3fTo/Qkg71rxC3etZ5jsTjW957V
        Yv6yp+wWV18eYHdg8ZjY/I7dY/OSeo/Pm+QCmKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNN
        zQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAlikplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVS
        C1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjP+v3nBUnCdtWLChatMDYyfWLoYOTkkBEwk
        Lh84ztTFyMUhJLCbUeLh+61gCSGBT4wSE35LQCQ+M0q8f7ETrmP6v40sEIldjBInnk6Dan/G
        KDFpzlNWkCoWAVWJxofbGLsYOTjYBDQlLkwuBQmLCMhJzFq6nw3EZhYIkuic380OYgsLOEj8
        v/8WLM4roCvxZtZFRghbUOLkzCdgizkFjCROv2gFs0UFlCUObIM4W0LgGrvEnA9XmCGuc5G4
        cmgXlC0s8er4FnYIW0riZX8blJ0s0br9MjvIbRICJRJLFqhDhO0lLu75ywRxW4bEtn1dTBBx
        WYmpp9ZBxfkken8/gYrzSuyYB2MrStybBPG6hIC4xMMZS6BsD4nlM26yQsKnlVGid/sr5gmM
        8rOQ/DYLyT4I20qi80MT6yyg85gFpCWW/+OAMDUl1u/SX8DIuopRMrWgODc9tdi0wCgvtRwe
        38n5uZsYwUlRy2sH48MHH/QOMTJxMB5ilOBgVhLhnaqaliTEm5JYWZValB9fVJqTWnyI0RQY
        VROZpUST84FpOa8k3tDE0sDEzMzMxNLYzFBJnPd0+oZEIYH0xJLU7NTUgtQimD4mDk6pBqZK
        DclTt859vMoYv+fYj4oJ2bPS2u7HhQU83d3q58bVl6PfVDKr3WH1U67V3/PimYNiayx8e/jj
        u8IUU3X2ZxwsdZjaaMrRk8kU+VQ8jE1ybudmz28RYXw87hfnsfNJ3ajO/fxVT91EinFe2//2
        SS3PGJxNZT32cDFsnfdokoRBctRpxqSzZ0OueHryn/dw+q9w+LiukJ1X9c+jcy7MW73VYtnm
        ZfvPNy7bUvl365KTC5PuVRRvFGm0el2bO7sgSC8k6XLb/6V5bqVfnj3bst6jzzV/W4Y3T1pa
        8YxZNofjZCYtquyc6JprPr+tyYPZ3pax3/TRgS0HOitszk094fS98cq8OMOqcuF58clvlViK
        MxINtZiLihMBQUX9VhMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsWy7bCSvO7OW+lJBrcXqVi8az3HYnGs7z2r
        xfxlT9ktrr48wO7A4jGx+R27x+Yl9R6fN8kFMEdx2aSk5mSWpRbp2yVwZZzebl7QyVzx8PIx
        5gbGfUxdjJwcEgImEtP/bWTpYuTiEBLYwSix+tA1VoiEuETztR/sELawxMp/z9khip4wSmy/
        +BOsiEVAVaLx4TbGLkYODjYBTYkLk0tBwiICchKzlu5nA7GZBYIkOud3g80RFnCQ+H//LVic
        V0BX4s2si4wQM1sZJb68v8EKkRCUODnzCQtEs5nEvM0PmUHmMwtISyz/xwES5hQwkjj9ohWs
        RFRAWeLAtuNMExgFZyHpnoWkexZC9wJG5lWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmb
        GMHBrKW1g3HPqg96hxiZOBgPMUpwMCuJ8E5VTUsS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuh
        62S8kEB6YklqdmpqQWoRTJaJg1Oqgcma28/fqWTaA8d7LJqrrDbonhJWD2U4uurL/8arzFNW
        yYld545unKbsUvDb2Cb2Vcslxemu/p8LJk/dr2+cdtd5xkcxVqn7K4MWbs6U6OMIX9K+X65F
        7kmyqUHB9S3+X+/f/HP1+YTLF862rVxj956j58Er62UGyf/DND3nTDhs+eNTo6uu7vO/Jxmm
        3bj1NyyEY3KJzN6Mu88OdrLEGJ3e9/FO2h+58kvXwtXnx/z9dPLn5bYbNzdd+TLX1rlf+/cV
        s8dL3ZoKt/2/mXL2zOOy+p3JgX9TmHfIXG6Q2CRynTcm8Y+M1I4a71dlvw8saD79WOHmCeWv
        Aoc/TjlrffZ1aoCbaz7/719H3gS3Len8psRSnJFoqMVcVJwIAGKYODjVAgAA
X-CMS-MailID: 20220426114249epcas5p238c9b454b6131672830beb8e44c6d721
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----NkeN6qpQV9bWnUH8GpeMhqJsD.tVVWOHd.rlqQ8kZmeldXuV=_10337_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220425182557epcas5p2e1b72edf0fcc4c21b2b96a32910a2736
References: <CGME20220425182557epcas5p2e1b72edf0fcc4c21b2b96a32910a2736@epcas5p2.samsung.com>
        <20220425182530.2442911-1-shr@fb.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

------NkeN6qpQV9bWnUH8GpeMhqJsD.tVVWOHd.rlqQ8kZmeldXuV=_10337_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Mon, Apr 25, 2022 at 11:25:18AM -0700, Stefan Roesch wrote:
>This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>To support the longer CQE's the allocation part is changed and when the CQE is
>accessed.

Few nits that I commented on, mostly on commit-messages.
Regardless of that, things look good.

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>



------NkeN6qpQV9bWnUH8GpeMhqJsD.tVVWOHd.rlqQ8kZmeldXuV=_10337_
Content-Type: text/plain; charset="utf-8"


------NkeN6qpQV9bWnUH8GpeMhqJsD.tVVWOHd.rlqQ8kZmeldXuV=_10337_--
