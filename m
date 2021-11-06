Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F10446CD4
	for <lists+io-uring@lfdr.de>; Sat,  6 Nov 2021 08:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhKFHIv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Nov 2021 03:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbhKFHIu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Nov 2021 03:08:50 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C6EC061570;
        Sat,  6 Nov 2021 00:06:01 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1636182359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDMr7z63ANiwgUIqESxEicrfEzmTYXOfCodnq6yrouI=;
        b=wr7gsNjaBJTobcl23roYYtsjIHMCyt/V1OCVL2bTO1mE1Utq3lFgYtGiAnLdV+deuGtTZ8
        f0hgXyxuv1P3zC2S7BFgtrDs4BYcf58w8hc0JH5Yeo9wejSINAmro+DaTClTT6dHxmTmpN
        lmfcWdi6Tw6thDPn1TTJukWNSYSdB9mdAo92hcrpWMezYJxs8S/LBWlURSCdw3uiW0yPQA
        Oin1yT1N30EBqSKU6U+5nE3PWIgJleWvgO0/5s44ypmhwl27uK4td1oal5Z/+hTF0iN0Iw
        D85+i7g43kN1Gk9/4dcACZuunrTuycR4qkWdMvnmyy8g0LPQTDMGS0ihNcBJLg==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 06 Nov 2021 08:05:55 +0100
Message-Id: <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
Cc:     <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Ammar Faizi" <ammarfaizi2@gnuweeb.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
In-Reply-To: <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Should I send a v2 or is this email sufficient:

Signed-off-by: Drew DeVault <sir@cmpwn.com>
