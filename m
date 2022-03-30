Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DAE4ECBF5
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350005AbiC3SZK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 14:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351208AbiC3SYh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 14:24:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8942D48312
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 11:22:04 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t4so15129903pgc.1
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 11:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6PnxJaVdYHTfEoSreao3ANO+XeqxY/p/4dxKSObIH1I=;
        b=BGpZ0SkxOm0fvRxqFYhC0b6sfacBYUvyfL63buMV2jU9Ji/4bjMz6Bgx+q8w9l+3i7
         oxE1Y4C1sA4AIffKs8JUo8ZpNEBafV3A8OuIgci3rBYzZoVkLXhmGoH+PO2uZ54XMgJD
         DcPiiZ8wLrGHKMNBP9VlXIEwNCXl+srU9PVfzEs/2LgGSV1IFHfg8Tc76RCdgJKGZSpH
         Tf5Ti3XrmOEMkFSgSXO9jl17haSCNxqkN3r6FWhQfB8jRwun81Px/PsY+526WeHapPe2
         dFXQcsbp2IOEnjr6xn5xH+zSt1z58gvkxZnvKDn/X3iGIlZHpqk4CYUgkOar58PEfT+I
         i1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=6PnxJaVdYHTfEoSreao3ANO+XeqxY/p/4dxKSObIH1I=;
        b=OX0CzT30/lHeoS9hLhdBjkcz8VUaLHL3s1IKdfhjZw0EMgxdfgVj/ketYgUFkF1HWi
         PQo6RIRGV39WPWDpCMt2dIrfy5MybKQtqDgyhsjytPcdHphlAdXhrQ6nKQB0wXUF4XU7
         vCh+W6RgHcWIL0Yv80kGh3N8L2UgnWQs1KBXlE4XePd9mGQiYCjxy6vCXuNVuIH8g3Yi
         voAu8f7L0B3iJV/FjhhYMEbIJTEAo/qTh922ODg7WtxaSTDnnOnlO5B84dOZxrmbdzgC
         nMD5ecAmecSdxGbf2U+srGCdhVCde7hAti/H/e9Ox78H4WKnEvKd36isikweTYyutlza
         p7BQ==
X-Gm-Message-State: AOAM533Dlknis9vrIgcLmEd90yNhEH3Q0KFkaz2jWK7Pl0Zs7IA8n0+4
        6nHbHrnWK5GnQrr+Y96EgUCFTS2jsRdE5/7I/w==
X-Google-Smtp-Source: ABdhPJzIAeq+/R41QnmeTf5IiaDtWHXbVt+NvO3bYeenbjFLgU8mUq/BFMBO3OjSlb8Gtf2HDG+eF1axEYzSfrr8r6o=
X-Received: by 2002:a05:6a00:1310:b0:4ca:cc46:20c7 with SMTP id
 j16-20020a056a00131000b004cacc4620c7mr845599pfu.44.1648664523252; Wed, 30 Mar
 2022 11:22:03 -0700 (PDT)
MIME-Version: 1.0
Reply-To: isabellasayouba0@gmail.com
Sender: 040stherchurch@gmail.com
Received: by 2002:a05:6a20:691d:b0:76:6cf5:d552 with HTTP; Wed, 30 Mar 2022
 11:22:02 -0700 (PDT)
From:   Mrs Isabella Sayouba <isabellasayouba0@gmail.com>
Date:   Wed, 30 Mar 2022 18:22:02 +0000
X-Google-Sender-Auth: YOktAgJDjfrHnqeTUc-upjh0fuc
Message-ID: <CAAzQq743hy3bOESCa_Rphqp09qF8oY9KYfqiDLdzWH7zXQP38A@mail.gmail.com>
Subject: =?UTF-8?B?44GC44GE44GV44Gk44CC?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_99,BAYES_999,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

44GC44GE44GV44Gk44CCDQoNCua2meOCkua1geOBl+OBquOBjOOCieOBk+OBruODoeODvOODq+OC
kuabuOOBhOOBpuOBhOOBvuOBmeOAguengeOBruebruOBq+OBr+Wkp+OBjeOBquaCsuOBl+OBv+OB
jOOBguOCiuOBvuOBmeOAguengeOBruWQjeWJjeOBr+OCpOOCtuODmeODqeODu+OCteODqOOCpuOD
kOOBleOCk+OBp+OBmeOAguODgeODpeODi+OCuOOCouWHuui6q+OBp+OAgeODluODq+OCreODiuOD
leOCoeOCveOBrueXhemZouOBi+OCiemAo+e1oeOCkuWPluOCiuOBvuOBmeOAguengeOBr+OBguOB
quOBn+OBq+W/g+OCkumWi+OBhOOBpuaEn+WLleOBl+OBn+OBruOBp+OAgeOBguOBquOBn+OBq+ip
seOBmeS7peWkluOBq+mBuOaKnuiCouOBr+OBguOCiuOBvuOBm+OCk+OAguengeOBr+OAgTIwMTHl
ubTjgavkuqHjgY/jgarjgovliY3jgavjg5bjg6vjgq3jg4rjg5XjgqHjgr3jga7jg4Hjg6Xjg4vj
grjjgqLlpKfkvb/jgag55bm06ZaT5YON44GE44Gm44GE44GfU2F5b3ViYQ0KQnJvd27msI/jgajn
tZDlqZrjgZfjgb7jgZfjgZ/jgILlrZDkvpvjgarjgZfjgacxMeW5tOmWk+e1kOWpmuOBl+OBn+OA
gg0KDQrlvbzjga/jgZ/jgaPjgZ815pel6ZaT57aa44GE44Gf55+t44GE55eF5rCX44Gu5b6M44Gn
5q2744Gr44G+44GX44Gf44CC5b2844Gu5q275b6M44CB56eB44Gv5YaN5ama44GX44Gq44GE44GT
44Go44Gr5rG644KB44G+44GX44Gf44CC5Lqh44GP44Gq44Gj44Gf5aSr44GM55Sf44GN44Gm44GE
44Gf44Go44GN44CB5b2844Gv57eP6aGNODUw5LiH44OJ44Or44KS6aCQ44GR44G+44GX44Gf44CC
DQrvvIg4MDDkuIc1MDAw44OJ44Or77yJ6KW/44Ki44OV44Oq44Kr44Gu44OW44Or44Kt44OK44OV
44Kh44K944Gu6aaW6YO944Ov44Ks44OJ44Kl44Kw44O844Gu6YqA6KGM44Gn44CC54++5Zyo44CB
44GT44Gu44GK6YeR44Gv44G+44Gg6YqA6KGM44Gr44GC44KK44G+44GZ44CC5b2844Gv44GT44Gu
44GK6YeR44KS44OW44Or44Kt44OK44OV44Kh44K944Gu6Ymx5qWt44GL44KJ44Gu6YeR44Gu6Ly4
5Ye644Gr5Yip55So44Gn44GN44KL44KI44GG44Gr44GX44G+44GX44Gf44CCDQoNCuacgOi/keOA
geengeOBruWMu+iAheOBr+engeOBjOeZjOOBqOiEs+WNkuS4reOBruWVj+mhjOOBruOBn+OCgeOB
qzfjg7bmnIjplpPjga/ntprjgYvjgarjgYTjgaDjgo3jgYbjgajnp4HjgavoqIDjgYTjgb7jgZfj
gZ/jgILnp4HjgpLmnIDjgoLmgqnjgb7jgZvjgabjgYTjgovjga7jga/ohLPljZLkuK3jga7nl4Xm
sJfjgafjgZnjgILnp4Hjga7nirbmhYvjgpLnn6XjgaPjgZ/jga7jgafjgIHnp4Hjga/jgZPjga7j
gYrph5HjgpLjgYLjgarjgZ/jgavmuKHjgZfjgabjgIHmgbXjgb7jgozjgarjgYTkurrjgIXjga7k
uJboqbHjgpLjgZnjgovjgZPjgajjgavjgZfjgb7jgZfjgZ/jgILjgYLjgarjgZ/jga/jgZPjga7j
gYrph5HjgpLnp4HjgYzjgZPjgZPjgafmjIfnpLrjgZnjgovmlrnms5XjgafliKnnlKjjgZnjgovj
gafjgZfjgofjgYbjgILnp4Hjga/jgYLjgarjgZ/jgavjgYLjgarjgZ/jga7lgIvkurrnmoTjgark
vb/nlKjjga7jgZ/jgoHjgavnt4/jgYrph5Hjga4zMOODkeODvOOCu+ODs+ODiOOCkuWPluOBo+OB
puassuOBl+OBhOOBp+OBmeOAguOBiumHkeOBrjcw77yF44Gv56eB44Gu5ZCN5YmN44Gn5a2k5YWQ
6Zmi44KS5bu644Gm44CB6YCa44KK44Gu6LKn44GX44GE5Lq644CF44KS5Yqp44GR44KL44Gf44KB
44Gr5L2/44GG44Gn44GX44KH44GG44CC56eB44Gv5a2k5YWQ44Go44GX44Gm6IKy44Gh44G+44GX
44Gf44GM44CB56We44Gu5a6244KS57at5oyB44GZ44KL44Gf44KB44Gg44GR44Gr44CB5a625peP
44Gr44Gv6Kqw44KC44GE44G+44Gb44KT44CC44GT44Gu55eF5rCX44GM56eB44KS44Go44Gm44KC
6Ium44GX44KB44Gf44Gu44Gn44CB56We44GM56eB44Gu572q44KS6LWm44GX44CB5qW95ZyS44Gn
56eB44Gu6a2C44KS5Y+X44GR5YWl44KM44KL44KI44GG44Gr44GT44KM44KS44GX44Gm44GE44KL
44Gu44Gn44GZ44CCDQoNCui/lOS/oeOCkuWPl+OBkeWPluOCiuasoeesrOOAgeODluODq+OCreOD
iuODleOCoeOCveOBrumKgOihjOOBrumAo+e1oeWFiOOCkuOBiuefpeOCieOBm+OBl+OBvuOBmeOA
guOBvuOBn+OAgemKgOihjOOBruePvuWcqOOBruWPl+WPluS6uuOBp+OBguOCi+OBk+OBqOOCkuio
vOaYjuOBmeOCi+aoqemZkOabuOOCkueZuuihjOOBmeOCi+OCiOOBhumKgOihjOmVt+OBq+aMh+ek
uuOBl+OBvuOBmeOAguengeOBjOOBk+OBk+OBp+i/sOOBueOBn+OCiOOBhuOBq+OBguOBquOBn+OB
jOOBneOCjOOBq+W/nOOBmOOBpuihjOWLleOBmeOCi+OBk+OBqOOCkuengeOBq+S/neiovOOBl+OB
puOBj+OBoOOBleOBhOOAgg0KDQrjgqTjgrbjg5njg6njg7vjgrXjg6jjgqbjg5DlpKvkurrjgYvj
gonjgIINCg==
