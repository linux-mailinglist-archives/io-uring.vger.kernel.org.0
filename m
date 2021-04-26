Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5DA36B1E9
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 12:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhDZKwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 06:52:07 -0400
Received: from mx01-muc.bfs.de ([193.174.230.67]:42897 "EHLO mx01-muc.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhDZKwH (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 26 Apr 2021 06:52:07 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2021 06:52:06 EDT
Received: from SRVEX01-SZ.bfs.intern (exchange-sz.bfs.de [10.129.90.31])
        by mx01-muc.bfs.de (Postfix) with ESMTPS id 77011203E3;
        Mon, 26 Apr 2021 12:44:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1619433843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CN1EadlOcJbMEc7RUViIyObDkCP4jxrU+GKcEXbe0Xg=;
        b=07I+Eddij4EPl+O3Lks6w4bT9ENPt6PSz/eF7PV1sIuT2rlAceYMeOOPif1kHj3UUzIuvR
        zYrHyPWhULgIjtmgbs7mlWpqHATb6g659AzY2iA1Ltn8pgoCTy3HKxj5N8lPgL6ijS+usI
        Q/CqJkidr6CT3H4ttFeigpI/queqxZo7XlSjv6FuRKKbWeWW/L5RLH8ZnXVEzHVSChMYG/
        cw/78M5sW84KDwn6Uo82f78wLmAEmAkP9aQyUmGEtI6ApNodOBnUrm27uAPxUcpI610BVR
        ibbyV/YhB7Z9dj5zzvzIKtcK5z/L6DB960kghfStoL3CQiKFnAGOHWAHc1FkHw==
Received: from SRVEX01-SZ.bfs.intern (10.129.90.31) by SRVEX01-SZ.bfs.intern
 (10.129.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2242.4; Mon, 26 Apr
 2021 12:44:02 +0200
Received: from SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a]) by
 SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a%13]) with mapi id
 15.01.2242.008; Mon, 26 Apr 2021 12:44:02 +0200
From:   Walter Harms <wharms@bfs.de>
To:     Colin King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH][next][V2] io_uring: Fix uninitialized variable up.resv
Thread-Topic: [PATCH][next][V2] io_uring: Fix uninitialized variable up.resv
Thread-Index: AQHXOoTfpdBElL+S8UuH+t8Syt902arGnMMm
Date:   Mon, 26 Apr 2021 10:44:02 +0000
Message-ID: <23460b552c344907bd6f254149519119@bfs.de>
References: <20210426101353.9237-1-colin.king@canonical.com>
In-Reply-To: <20210426101353.9237-1-colin.king@canonical.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.137.16.40]
x-tm-as-product-ver: SMEX-14.0.0.3080-8.6.1012-26114.006
x-tm-as-result: No-10-0.663500-5.000000
x-tmase-matchedrid: dtkKbEKn3AnRubRCcrbc5grcxrzwsv5u3dCmvEa6IiGoLZarzrrPme6X
        ODXRWDdKxkb9fACVrLIWgZoMea78SXgEmMsrY8ykiVJZi91I9JgORjM32hn2b63DfQXYDXXmRiM
        0r5DoZkAcEwO4f1ey3nakECIa+Y+L35CXmGCLTEU5FhAF440dkZ54zspPOxzffGAgiBknOLXxZ8
        6WI5OtobTU+D0ttl649Zy0Abon06cB5jDL4tJv076EJGSqPePTRiPTMMc/MmkDAA5uRHailgN06
        QRaBqZ4jxqOaLLtmI1c4eBDXe7orqp9JB8tr9I3LZ01719etEh8s0cy6t/KSDVjvc93O9dkQBzo
        PKhLasiPqQJ9fQR1zkgXurX+wtIA/Vk1QoTj6earm7DrUlmNkF+24nCsUSFNjaPj0W1qn0TKayT
        /BQTiGtQYs0qry+30Z0NSz7eJS83lOFtSxQd27Sha0WRI/FvmUd+sqX3TeLAJ3PUOotbczqKexv
        pua0brgVArSQ9tw7eIji5iFASLgGk5lMFB6EFJcCmyZvDwQy2t5ahRvDIGLa2t1VXHehFeLnS15
        FcU1hfvdCUIFuasqw==
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
x-tmase-result: 10-0.663500-5.000000
x-tmase-version: SMEX-14.0.0.3080-8.6.1012-26114.006
x-tm-snts-smtp: 6D111E8F88184EEAC1061FD27B2F032A87388310536EA6692307AC678EE65E282000:9
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spamd-Result: default: False [-16.50 / 7.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         HAS_XOIP(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCPT_COUNT_FIVE(0.00)[6];
         DKIM_SIGNED(0.00)[bfs.de:s=dkim201901];
         BAYES_HAM(-3.00)[99.99%];
         WHITELIST_LOCAL_IP(-15.00)[10.129.90.31];
         FREEMAIL_TO(0.00)[canonical.com,kernel.dk,gmail.com,vger.kernel.org];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Authentication-Results: mx01-muc.bfs.de;
        none
X-Spam-Status: No, score=-16.50
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

why not:
 struct io_uring_rsrc_update up=3D{0};

would be future proof :)

jm2c,

re,
 wh
________________________________________
Von: Colin King <colin.king@canonical.com>
Gesendet: Montag, 26. April 2021 12:13:53
An: Jens Axboe; Pavel Begunkov; io-uring@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
Betreff: [PATCH][next][V2] io_uring: Fix uninitialized variable up.resv

WARNUNG: Diese E-Mail kam von au=DFerhalb der Organisation. Klicken Sie nic=
ht auf Links oder =F6ffnen Sie keine Anh=E4nge, es sei denn, Sie kennen den=
/die Absender*in und wissen, dass der Inhalt sicher ist.


From: Colin Ian King <colin.king@canonical.com>

The variable up.resv is not initialized and is being checking for a
non-zero value in the call to _io_register_rsrc_update. Fix this by
explicitly setting up.resv to 0.

Addresses-Coverity: ("Uninitialized scalar variable)"
Fixes: c3bdad027183 ("io_uring: add generic rsrc update with tags")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---

V2: replace "pointer" in commit message with "up.resv"

---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f4ec092c23f4..63f610ee274b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5842,6 +5842,7 @@ static int io_files_update(struct io_kiocb *req, unsi=
gned int issue_flags)
        up.data =3D req->rsrc_update.arg;
        up.nr =3D 0;
        up.tags =3D 0;
+       up.resv =3D 0;

        mutex_lock(&ctx->uring_lock);
        ret =3D __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
--
2.30.2

