Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294DA4B5FEC
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 02:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiBOBRF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 20:17:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiBOBRE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 20:17:04 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB8A8BF6C
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 17:16:56 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id h8so14410134ejy.4
        for <io-uring@vger.kernel.org>; Mon, 14 Feb 2022 17:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=khFlKyL1ha/xVPi4Z/tm+G2VlHL6EyOop4wEzn3U5zk=;
        b=pqo9f7VEI5I5E5G3qO2Uk8xfibU5RNUnNtHcN08PEqqH1847Ywk3Nn8HlQ3rKsGij4
         FW2EqKgnGu78rO+7xM7QuiH9aKSUcuGZrz0HI3FlLp3rotL+LFL0A+WXMLCoiVvrn5Zr
         FWVIKw7X0Jdhe7kTyGzQvLFeUwtl2hcQPyR6Wq+TTOZaIB2iCzGI/heGiCWf6/K7hy/B
         qwe4If2B196KJCwWBa3EYMGVuTo6FGcGeIu218ellwQzE97CBfsdjDUcpixMBLzwu+WK
         rIudbpq+9fD5mQxtK01xRgmC1oG9lv4/J3N7eyptsqgW72hXcVQPLRHoonyFNWk26pA/
         1UYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=khFlKyL1ha/xVPi4Z/tm+G2VlHL6EyOop4wEzn3U5zk=;
        b=v91pq8uEyL8+G0fYHdOZivK4H9GP6cdiyqvUCttQsOJt6MmbcRsOIuk2JmlVZ1Ic+h
         rKQxRt2VDKKkoA9uyT3+pHzLbu4iDh1n6y/Teg2kA2HVSF9CS3MOMMCtNDOA1icJ5d/E
         cOLzEMevjeyyphT/5kQUS+dXsjtOpkTpiGPtovapZQ/oLBIdTT0m5leGmvkNqYk4RDBA
         6LDOVDRmH8+XPLxW4K+GexcLqt0taJrh1c+u3fksNotL0ly1uXVBCJ8QwE7+EmTXsMX0
         qpwV5fLFNvT6cwINqttNomreejCI/YOB6Cqzpbrq6pgtzvsiFixJ4CBNAWBcFsAq7AbA
         sK1g==
X-Gm-Message-State: AOAM531uYZddL59dmvFVs1F+8mSw6NR7HBhs9nEnQEOCfULT8M9ljk2S
        q43HAiUsE0eGcqrAh09uX+Eih1o1nvWlX4KzRHw=
X-Google-Smtp-Source: ABdhPJyNTp+4ETmg1uiOLl1ZJR/n5cTotaWRGw9byul0QFE61ppIDZDUhWtxrmmu5+UD4pNBArviZ8ReGffbo/r/tjU=
X-Received: by 2002:a17:906:5186:: with SMTP id y6mr1118038ejk.40.1644887814422;
 Mon, 14 Feb 2022 17:16:54 -0800 (PST)
MIME-Version: 1.0
Sender: aaisihagaddafi@gmail.com
Received: by 2002:a17:906:1988:0:0:0:0 with HTTP; Mon, 14 Feb 2022 17:16:53
 -0800 (PST)
From:   Aaisiha Gaddafi <madamisha00@gmail.com>
Date:   Tue, 15 Feb 2022 02:16:53 +0100
X-Google-Sender-Auth: E8PfBewOJWluQ4J-qrLJEOBgoCg
Message-ID: <CA+QJJgD6yrCma=zg5jWSEPmHT-bEQT4GrjcV_dGrBH=wpDRwWQ@mail.gmail.com>
Subject: I want to invest in your country
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MILLION_HUNDRED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--=20
I want to invest in your country
Greetings Sir/Madam.
May i use this medium to open a mutual communication with you, and
seeking your acceptance towards investing in your country under your
management as my partner, My name is Aisha Gaddafi , i am a Widow and
single Mother with three Children, the only biological Daughter of
late Libyan President (Late Colonel Muammar Gaddafi) and presently i
am under political asylum protection by the  Government of this
nation.
I have funds worth =E2=80=9CTwenty Seven Million Five Hundred Thousand Unit=
ed
State Dollars=E2=80=9D -$27.500.000.00 US Dollars which i want to entrust o=
n
you for investment project in your country. If you are willing to
handle this project on my behalf, kindly reply urgent to enable me
provide you more details to start the transfer process.
I shall appreciate your urgent response through my email address
below: gaddafi.mrsaisha@bk.ru
Thanks
Yours Truly Aisha
