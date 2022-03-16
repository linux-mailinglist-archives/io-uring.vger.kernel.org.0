Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556654DB84A
	for <lists+io-uring@lfdr.de>; Wed, 16 Mar 2022 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbiCPS5J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 14:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357839AbiCPS5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 14:57:08 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635226E4E4
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 11:55:53 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d19so4803793pfv.7
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=IDPpGsUWxk+2ss+hOwztUiPV0w2T2AyiU2FD77oZ8tU=;
        b=PwkFmHYiIvqIO00fhbFVvc/me3MvY8PNz+fBE3SrP/2I2o1FwIt1iHPKFHBCxHxXPH
         QJtxzyDR51fu8hkagI7VHgx/g//UmzkUudxz6KSi/1AvvlVAvUBzriTtvtKoE5eygJ5/
         7HkLmm4zlVBDGYnYKbdoHR9x77oGAt4Q9bTjRnBO4rQKkdOMhaeBabbwiveuF2xeKI4u
         qacEiD1dc/aCIjdLKva69ua2HsA7K5Q9S08BwHY3CC4vC0A5ERuuc1n6HxzC4ObRZgTo
         49AaFswhUcye+VgAa7HxWHmVSWBdTPOjM4V486uQp3rVMZ1yJfI6Q4EwclTKTYFkhZg9
         9FIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=IDPpGsUWxk+2ss+hOwztUiPV0w2T2AyiU2FD77oZ8tU=;
        b=KGAtm6VrniihLAU039SskOywAuGWoPFx2j6fy0+a1nNsko2MV9dfuAcE2yZl+O1KaI
         91rq6akmefMiJtUNYBmI9VPu0ZhljMfKePsXhPlSXmwAJfsTbZ9be48rLE39PE48FYCG
         ZYcPbTIh0itm45fgCokRB7eVGAiiKerlFPYEBqINP1cCVYa9ZWXtHGI/wENG6LvO0fBJ
         aNXRtCs4euopcaQZyTqxKFtgL9Xbwi9gU8zFYUJ5wotsNdp6GGnA2UNcSoGs9bOYhlEG
         MXlB9nH5EYqvsA4VNxHG/dhffG0qoU4014dkj7RcWdAx4/mDlsLNPlekiokuLLO8bqOl
         Rbtg==
X-Gm-Message-State: AOAM533l5ySRymk133DlzWk3bBdDz2U/eWbm2NCi69KkosaAVtnGtZFB
        rzk6+CwE0QZSMMdG8w6i/qRNzaSVCsMtS83E
X-Google-Smtp-Source: ABdhPJzznHjRYe6iVb/PHwSxZftpfQP0fz1DIM0MCtOP7BsYlRCw13fNXHpOK02ZSrWapec6e3K0lg==
X-Received: by 2002:aa7:81c1:0:b0:4f7:6ba1:553b with SMTP id c1-20020aa781c1000000b004f76ba1553bmr1221180pfn.45.1647456952404;
        Wed, 16 Mar 2022 11:55:52 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e8::1b2e? ([2620:10d:c090:400::5:fc73])
        by smtp.gmail.com with ESMTPSA id bg3-20020a17090b0d8300b001c6077ea0edsm7222055pjb.23.2022.03.16.11.55.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 11:55:52 -0700 (PDT)
Message-ID: <513adf9d-4344-cfc5-9d4b-49a712939394@kernel.dk>
Date:   Wed, 16 Mar 2022 12:55:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: move req->poll_refs into previous struct hole
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This serves two purposes:

- We now have the last cacheline mostly unused for generic workloads,
  instead of having to pull in the poll refs explicitly for workloads
  that rely on poll arming.

- It shrinks the io_kiocb from 232 to 224 bytes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b17cf54653df..fa4e2cb47e56 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -908,6 +908,7 @@ struct io_kiocb {
 	/* used by request caches, completion batching and iopoll */
 	struct io_wq_work_node		comp_list;
 	atomic_t			refs;
+	atomic_t			poll_refs;
 	struct io_kiocb			*link;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
@@ -916,12 +917,11 @@ struct io_kiocb {
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
-	struct io_wq_work		work;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
-	const struct cred		*creds;
 	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
-	atomic_t			poll_refs;
+	const struct cred		*creds;
+	struct io_wq_work		work;
 };
 
 struct io_tctx_node {

-- 
Jens Axboe

