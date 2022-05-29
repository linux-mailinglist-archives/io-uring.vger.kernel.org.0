Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F625371C2
	for <lists+io-uring@lfdr.de>; Sun, 29 May 2022 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiE2QUJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 12:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiE2QUI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 12:20:08 -0400
Received: from pv50p00im-ztdg10012001.me.com (pv50p00im-ztdg10012001.me.com [17.58.6.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B86522F4
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 09:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653841207;
        bh=4Rr5KXIx6+kE8zBz9lvs+VutHi0HB5g+sXpnfiDX86A=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=KqeRHZ4UXnuFcc72ABfPrU5b+fODnWnfDsNFPlyPBpycATgx37Wdv2f1Gz1RHcwkp
         +k/kMRCn+oSvOevPVkidOeayqrsuvQVrIO1VGkRQrbxbGMdlSrrQVuRwcCWtwpecqv
         G0riwcFLQQOGJbiDqLZgJ/6hUUAd1KslVtN7dj++CtuY5t2HRYrRM7ABMEWQtcNG9c
         zCeCLiUtZxib/EwSeHEVC+NWqQNx34ugnVYx5ft8ae43u+eSiYZT0EXQdH4KXW4wKX
         ne31zxK46dzqbPCHradoRoMOZt42swg57VjtFxftXh8sCQOFsWvpu4JVVRRYjEj3Uc
         8bdpCNqAzz4qA==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10012001.me.com (Postfix) with ESMTPSA id 8B736A0389;
        Sun, 29 May 2022 16:20:05 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 0/2] cancel_hash per entry lock
Date:   Mon, 30 May 2022 00:19:58 +0800
Message-Id: <20220529162000.32489-1-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-29_03:2022-05-27,2022-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=470 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205290095
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Make per entry lock for cancel_hash array, this reduces usage of
completion_lock and contension between cancel_hash entries.


Hao Xu (2):
  io_uring: add an argument for io_poll_disarm()
  io_uring: switch cancel_hash to use per list spinlock

 io_uring/cancel.c         | 12 ++++++++++--
 io_uring/cancel.h         |  1 +
 io_uring/io_uring.c       |  9 +++++++++
 io_uring/io_uring_types.h |  1 +
 io_uring/poll.c           | 38 +++++++++++++++++++++-----------------
 5 files changed, 42 insertions(+), 19 deletions(-)


base-commit: cbbf9a4865526c55a6a984ef69578def9944f319
-- 
2.25.1

