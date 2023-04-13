Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180816E0D92
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjDMMkv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 08:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjDMMkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 08:40:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1038F93FE
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 05:40:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-2470f9acb51so114678a91.0
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 05:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681389644; x=1683981644;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cwd2v8mzGDF6xpnZRHjLcF96vd+/rBIKNPGTDx6xCUA=;
        b=A4ycF8td4NL0GFqmjWm1j2PwLN+yXmD9wVV+JPYdfqh3AOWfDZnEl1qibnIbk0/uSG
         TpIakF6CEw+k5B+/RyHHOR2N9Inf8DlcZYBsqyrKLZyNA/uFwYGmpqjhiypg0pG5PpsK
         +ND9FRnOK9+PDRVqL5onB3GYIMmc/W6HOFr0B50LrqidZZS6QhbRz2ZSmnhzvstQzOQX
         +qmfGmVZnUKkaz+ij9NwivMOW86getwO+fdshMVwqQS+YJzoBw1UnL4BKkRc7SlOwbCd
         59k+cgI0w6Kj8su0qysGGwdyAypysc0GZknDY9ksj2GPJmNsZviHTatlivPWRKPTCUMJ
         OE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681389644; x=1683981644;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cwd2v8mzGDF6xpnZRHjLcF96vd+/rBIKNPGTDx6xCUA=;
        b=QZg4AfWeybb3droAnD6JUMQk6S2cBAHwwk1tR46JB8bsTdcGi6LEEmGuCKmuTdwpA6
         uIaiZ9SEwUDACx+zTQbDX0I+7weJLPLfvy5Kgefs+ls923aiWaE0QnGndRxoe6nMnIRt
         DR9qbYmZ/kYrnC++dG4fRFI+QqnnXT+ugOuBa7keLJxAWdN22f8NXx3M/b+Q5iuvrpA2
         5JVi9qnCNfBYN3r3h6wG916CqY7Zu0YjRDDbN0bORFNuMPn6URgl6BtUZV6dGhnmQGZt
         4/cu/jJC637SsEuWmGi47r0sKRXeG8IjIVUkRkYwBLO7EaiJ7NyL865ZkwpewMYZK77n
         ZVNQ==
X-Gm-Message-State: AAQBX9cG7gPW2niG+eCkpDUgj7viGHJoacp2G1fxTYkhFyjP51IwwO8a
        pvIaUbyPZu6fe8D1SDeg5yo8R+0PFgJvIGV0kLw=
X-Google-Smtp-Source: AKy350bfIaEU86uqnOYfE8zQ6Gi4JDfRJH0rwa8yGgTyizhld7UgKTSpuya3RQPQo+3WUz6Djh3B3g==
X-Received: by 2002:a17:90a:347:b0:237:40a5:77cb with SMTP id 7-20020a17090a034700b0023740a577cbmr1823188pjf.1.1681389644432;
        Thu, 13 Apr 2023 05:40:44 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id az6-20020a170902a58600b0019a70a85e8fsm1401283plb.220.2023.04.13.05.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 05:40:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <20230413104714.57703-1-xiaoguang.wang@linux.alibaba.com>
References: <20230413104714.57703-1-xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH] t/io_uring: fix max_blocks calculation in nvme
 passthrough mode
Message-Id: <168138964374.4971.17741240734839903177.b4-ty@kernel.dk>
Date:   Thu, 13 Apr 2023 06:40:43 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 13 Apr 2023 18:47:14 +0800, Xiaoguang Wang wrote:
> nvme_id_ns's nsze has already been counted in logical blocks, so
> there is no need to divide by bs.
> 
> 

Applied, thanks!

[1/1] t/io_uring: fix max_blocks calculation in nvme passthrough mode
      commit: e2a4a77e483e2d40a680b57b13bb08042929df1c

Best regards,
-- 
Jens Axboe



