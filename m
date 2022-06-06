Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDAA53E383
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 10:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiFFG53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 02:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiFFG52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 02:57:28 -0400
Received: from pv50p00im-tydg10021701.me.com (pv50p00im-tydg10021701.me.com [17.58.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C87322B0B
        for <io-uring@vger.kernel.org>; Sun,  5 Jun 2022 23:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654498646;
        bh=3fUXyXQvDgbnT1QjYSoo4uOyFzF5gsP9oyMLnmItu6Y=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=qZkqXIClHDLXJOQkx2NK4lDTPF37E+CaHVo/LOEBjFnvNjW7r6V6wrQu/5Mmfgg8O
         O0IGQZWD+VyPlOjSuaa61j5Dyfz1E+rZ+78Oa8TBmwlN1cliOhGbNr3/sIgefaPi9N
         Ypg/uFb0C0pMaHHNumT6Go9htRVABhSctaOjt8uGO4BNQUv3o/y46//vy/adoJEw/a
         qet7OT/v0W6MIixIARLXFpgeAvHWSJ0YPLBcDYlV4ddfjMtFLgTRVZXRXbwenMM1rj
         9dTXBGzuAnrWMnWGQYq06WL/+08M9ctpFMQ+DhP+GPOWt79Dc0FVsBigKS8w8dpU3c
         FCsdPkkglT6RA==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10021701.me.com (Postfix) with ESMTPSA id 49FC03A0D74;
        Mon,  6 Jun 2022 06:57:23 +0000 (UTC)
From:   Hao Xu <haoxu.linux@icloud.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 0/3] cancel_hash per entry lock
Date:   Mon,  6 Jun 2022 14:57:13 +0800
Message-Id: <20220606065716.270879-1-haoxu.linux@icloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_02:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=388 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060031
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

v1->v2:
 - Add per entry lock for poll/apoll task work code which was missed
   in v1
 - add an member in io_kiocb to track req's indice in cancel_hash

Hao Xu (3):
  io_uring: add hash_index and its logic to track req in cancel_hash
  io_uring: add an io_hash_bucket structure for smaller granularity lock
  io_uring: switch cancel_hash to use per list spinlock

 io_uring/cancel.c         | 15 +++++++--
 io_uring/cancel.h         |  6 ++++
 io_uring/fdinfo.c         |  9 ++++--
 io_uring/io_uring.c       |  8 +++--
 io_uring/io_uring_types.h |  3 +-
 io_uring/poll.c           | 64 +++++++++++++++++++++------------------
 6 files changed, 67 insertions(+), 38 deletions(-)


base-commit: d8271bf021438f468dab3cd84fe5279b5bbcead8
-- 
2.25.1

