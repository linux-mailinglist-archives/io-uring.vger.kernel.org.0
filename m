Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BCB66CB0C
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 18:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbjAPRKL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 12:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbjAPRJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 12:09:31 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573DB30B02
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:01 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r9so5270656wrw.4
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 08:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wyP6xuJ43IEG1OBKyv4Guim5bBzj5e2Ex31nh4bOPHQ=;
        b=X0HeeTcZFbMfMZj5xg+eQEk6No7/uLVdIv/eGoQIDKYXPj90875+M8h2imma919OHD
         TcuWXesRuAcXsJjr3cVrT+s4BNDH8ZTaILo4YNI+theyKdUf8jyAEu25gvj95do5c6Bm
         hCwDJVBv1urduy2enmoF+RxhluxgoF7LNgIsiQa0MT1muOBB0epLw5Ip9VlozRJ4nYyi
         W6994tJLmfEH/5sE7tuFsA4iWe++D+/hnw095Ohgo4VEdjlD6FRUybA3cEIJGhzQ8AUG
         EDuTW5m66kkwwbd+KaUBZttOK7tImHDU1wqFgwMjam6KO3zK/JfHx/nVQQHoAHWOx6m5
         8XBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wyP6xuJ43IEG1OBKyv4Guim5bBzj5e2Ex31nh4bOPHQ=;
        b=KElb2NUoEHXRpoGbIbz4IZytVd0ssV0PU4Hkqs6X5fm78iUMnBrEehzldW1CtIal9E
         867RxA+R+trAaAQ/SCcE3xIf5RRIg2LZCYMi7keaLTCnSu94DaWfksJC9JMsTTsb+mxn
         QkHuzFjw+BOlLICrg6QrlpQcWAa7t40shzLi7Gsmjx717BEue7GgYpHMnqQYgAmPvFwu
         hFdEPw8slL1QGAxNBQxTHbJCsEZFJQqzOPspfq1b+lzZPktKEGmgRdHr0a8/Zzsyk++P
         qR9AWSr0ROXlmuyi569vZ4ImQCdHB5QiNzcG6rS6rKf8rX1cEHKouY2XGO1lImzObAu3
         ZbeA==
X-Gm-Message-State: AFqh2kpXhqVUsPthOw//ntEC5taCGuekBPEvEmWRFOWLCqot0xe//A4U
        jXjwnXpckoFksq8eZXr4XQRFYiUsXaY=
X-Google-Smtp-Source: AMrXdXvbS6DvaKDlmGQE0XjvFU5b693L258KCbujxrPSxxfIM+tRJJLROgMc8ax3uDPIlEb2wUF2eg==
X-Received: by 2002:adf:ea02:0:b0:2bd:f549:e4c with SMTP id q2-20020adfea02000000b002bdf5490e4cmr149371wrm.14.1673887799750;
        Mon, 16 Jan 2023 08:49:59 -0800 (PST)
Received: from 127.0.0.1localhost (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d62c7000000b002bbeda3809csm20872372wrv.11.2023.01.16.08.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 08:49:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/5] random for-next patches
Date:   Mon, 16 Jan 2023 16:48:56 +0000
Message-Id: <cover.1673887636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1/5 returns back an old lost optimisation
Others are small cleanups

Pavel Begunkov (5):
  io_uring: return back links tw run optimisation
  io_uring: don't export io_put_task()
  io_uring: simplify fallback execution
  io_uring: optimise ctx flags layout
  io_uring: refactor __io_req_complete_post

 include/linux/io_uring_types.h |  6 +++---
 io_uring/io_uring.c            | 34 ++++++++++++++++++++++------------
 io_uring/io_uring.h            | 10 ----------
 3 files changed, 25 insertions(+), 25 deletions(-)

-- 
2.38.1

