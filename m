Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FF850696F
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 13:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346610AbiDSLKY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 07:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350894AbiDSLKX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 07:10:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A5A2AC71
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 04:07:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id t11so32077384eju.13
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 04:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:organization:content-transfer-encoding;
        bh=SVzQZcyELwbjO6gcVnQuwsmE988o1HdnwZsLFPjqfmU=;
        b=qvgYVU7DPdwmfTOZB3EbXI0M57I3Eqtv0rf3HdBU8exuwAYNR2xbMTrRBnYPhxxEC1
         qJKOl1ruBo/T91gSczzfEQuVjdeI0bxLW73HMQyqufgLSnCqjHuVys1zQ3nG6oOQGBUi
         uhnleXnIuNFL46irQnzIqxvChYjv2GwxO29RvLRHDQ2659bCJna0FOCtSOn+MjJLdrZ1
         xaiYWj2IDxoj2Hn5xfL3qcWbZY4pPdSpLsgm4xclotOVKdQ3OOwz12+ONQHvWAAHjDOm
         YmVXk+DKvFaGf+OVe1ajLkhz3f6gDCNX3d1j46GuJ+R7JmroRv839rTG0RaPxRsqNyfW
         YzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:organization
         :content-transfer-encoding;
        bh=SVzQZcyELwbjO6gcVnQuwsmE988o1HdnwZsLFPjqfmU=;
        b=VDozUlfoszlS8mK0n3g+J5h00QBD6OmnIz3YRf3ALYiUSxRDNIlrihysrnMecc+FaF
         Z3vmUKmdaaSSgTysUl+ASIF1vKfkc/ERcMmsDG8rlcUpamfvHtld9RoAAKqbcUu5DlyX
         zC4R0A7gm4lfqLRDKUMLgxoyJ70Ux/i0KCKWjdZwlAST1jKZ+ZMpnhxO3bGHiaV262Zh
         KxeAxFZbV5PaCfJR/fs6kImYsL23yL81q4Ju178MsHGpOtmv1n7kUFiOTEOh+l7Bu0Lm
         gm6Uecamj0l9MwrUYfHPH0oDbesqVb/dMCKhM30Oct7mZL6rSoiH0I99Vl2SRJXBDEnG
         2AFQ==
X-Gm-Message-State: AOAM530RsVxdx38/TBVWbhTPjGIB0JdX0UYm2TE7fWsecUHSnG+4YOyZ
        xqSu7h5Xgz0mdE0H3lF+Fu6zPbOi9T0NlA==
X-Google-Smtp-Source: ABdhPJww14ZQGbLDYZA2ypaXtduemWBPGQQtfCvc7EkuobJQEaQ0PAq3Ms7sxqaX4CikRgwXrmVJpA==
X-Received: by 2002:a17:907:1c8f:b0:6e8:f898:63bb with SMTP id nb15-20020a1709071c8f00b006e8f89863bbmr13368609ejc.721.1650366459224;
        Tue, 19 Apr 2022 04:07:39 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id e9-20020a17090618e900b006e8669f3941sm5499342ejf.209.2022.04.19.04.07.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 04:07:38 -0700 (PDT)
Message-ID: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
Date:   Tue, 19 Apr 2022 14:07:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     io-uring@vger.kernel.org
From:   Avi Kivity <avi@scylladb.com>
Subject: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Organization: ScyllaDB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A simple webserver shows about 5% loss compared to linux-aio.


I expect the loss is due to an optimization that io_uring lacks - inline 
completion vs workqueue completion:


static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, 
int sync,
                 void *key)
{
         struct poll_iocb *req = container_of(wait, struct poll_iocb, wait);
         struct aio_kiocb *iocb = container_of(req, struct aio_kiocb, poll);
         __poll_t mask = key_to_poll(key);
         unsigned long flags;

         /* for instances that support it check for an event match first: */
         if (mask && !(mask & req->events))
                 return 0;

         /*
          * Complete the request inline if possible.  This requires that 
three
          * conditions be met:
          *   1. An event mask must have been passed.  If a plain wakeup 
was done
          *      instead, then mask == 0 and we have to call vfs_poll() 
to get
          *      the events, so inline completion isn't possible.
          *   2. The completion work must not have already been scheduled.
          *   3. ctx_lock must not be busy.  We have to use trylock 
because we
          *      already hold the waitqueue lock, so this inverts the normal
          *      locking order.  Use irqsave/irqrestore because not all
          *      filesystems (e.g. fuse) call this function with IRQs 
disabled,
          *      yet IRQs have to be disabled before ctx_lock is obtained.
          */
         if (mask && !req->work_scheduled &&
spin_trylock_irqsave(&iocb->ki_ctx->ctx_lock, flags)) {
                 struct kioctx *ctx = iocb->ki_ctx;

                 list_del_init(&req->wait.entry);
                 list_del(&iocb->ki_list);
                 iocb->ki_res.res = mangle_poll(mask);
                 if (iocb->ki_eventfd && !eventfd_signal_allowed()) {
                         iocb = NULL;
                         INIT_WORK(&req->work, aio_poll_put_work);
                         schedule_work(&req->work);
                 }
                 spin_unlock_irqrestore(&ctx->ctx_lock, flags);
                 if (iocb)
                         iocb_put(iocb);
         } else {

