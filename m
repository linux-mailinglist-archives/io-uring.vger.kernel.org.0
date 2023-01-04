Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EAA65DDE0
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 21:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjADUwN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 15:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjADUwM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 15:52:12 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696D43C3A1
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 12:52:11 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id d10so20089119ilc.12
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 12:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3/HRiIbr2uvpe4motP3esrdo4my2l+KFiHyT4rzsbQ=;
        b=RlNUJIZLNRUqbY8Wud6iQhfBmf/w9o7+rfs4InB3WQ3Ya2MCq3QITqYdMPwkQCq1SX
         +t3nrwtZD+4G5JPx2UxPfyOL+mV8ktkf4a32lHW3cBl4OOuTMuH8ajVahhCpr15a8/p9
         d7V4bWrzVLnT0k1Or91Vs6DpkA4WOKWEJ/5qgZMxpDMVVBtjkk6pM+JO1slV/0EViqEd
         h1MAJDJh3rXci6brMrEZmzf66bMtW55Vnk78sRHaoxLXL2s4AX+X03znXyWX8xoIgvMW
         D0Egy0l7DJW9SATho4S5ZDaiLs4uHrd9MYY4L9A2b9i178ILZruazWKHd9Yrb3/AfJT2
         pTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U3/HRiIbr2uvpe4motP3esrdo4my2l+KFiHyT4rzsbQ=;
        b=QOTigQQFmJeUN/6/ROtDzHbCU2eLNvxeGi82EZyffe2xH48f6gVFPRSu+nMHeFYNgX
         wRD+MxUTLNgYFL2sgphyGQhm+XxOBVMs8dNJcL1v5VYMezOz05WdAIQFpo07xh0nYg7Y
         7743BjaT9VrxZpdfejPAGqw/lNTcKkiC4PYZ7oS5MZn9yjDNPS37RuKCmbP9VDX+NNlO
         QTSxNw2hUxk6oBaVjUDfWFiULxQYiQ21efKXv9umgvCYOGe4BgBG2t9SQ2Y6XvQ2c18x
         XDzcyTLq0wLPUTKfZ6Gkow3Yw87xSbnmNGTE21HIbowUXxzdStPheORa1D0OqvUajwi3
         kl5g==
X-Gm-Message-State: AFqh2kqjj16A/yVy7NgfOsTmsszo2Lt7T+hG8PdTpjvF5FIonrl0ggR4
        tFoMBiDRe4uusOGD+dAV7fzAEOLthWeIaDwT
X-Google-Smtp-Source: AMrXdXv9q53G1cX6UlwqBcqec6ecv35szfzoQDlEmWEt+BYEfC8AuaP5mzwbE1gMt0mM3tlDC14KIg==
X-Received: by 2002:a92:c9cb:0:b0:304:c683:3c8a with SMTP id k11-20020a92c9cb000000b00304c6833c8amr6472511ilq.3.1672865530478;
        Wed, 04 Jan 2023 12:52:10 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o7-20020a927307000000b0030005ae9241sm10916863ilc.43.2023.01.04.12.52.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:52:10 -0800 (PST)
Message-ID: <5c3b0571-ee3b-5bf1-50ce-a2009ee219d5@kernel.dk>
Date:   Wed, 4 Jan 2023 13:52:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: move 'poll_multi_queue' bool in io_ring_ctx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The cacheline section holding this variable has two gaps, where one is
caused by this bool not packing well with structs. This causes it to
blow into the next cacheline. Move the variable, shrinking io_ring_ctx
by a full cacheline in size.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index dcd8a563ab52..128a67a40065 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -292,6 +292,8 @@ struct io_ring_ctx {
 	struct {
 		spinlock_t		completion_lock;
 
+		bool			poll_multi_queue;
+
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
 		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
@@ -300,7 +302,6 @@ struct io_ring_ctx {
 		 */
 		struct io_wq_work_list	iopoll_list;
 		struct io_hash_table	cancel_table;
-		bool			poll_multi_queue;
 
 		struct llist_head	work_llist;
 
-- 
Jens Axboe

