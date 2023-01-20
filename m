Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94AD6675A1D
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjATQhd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjATQhc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:37:32 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2A4702B3
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:37:05 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d9so5775872pll.9
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ZHscXVDnqtQcuqFlK/F2h4eSbihIIcX+F66112PRak=;
        b=iKC7zE/Y9W2+df5UpncAhYv9/PTFaqC+KDcaJzszQFp+SOD+ujGQclW/hTo81vXXch
         wKxC0tvC5bL4lmcVE7fusDCg7hs/LKzjFchNM8VB+AC95bLs0WbwnsfVk9H5wLenLTXd
         jnGGTHrFIvjEv9i7DJBzuGjK3aMiyin2tx9oLgPAMbAabXH1x3qLpgQNDQzFZMLq2KUI
         NfwqY4v99thYgQs3kz9INudO01LildX1OXEHcj7mURpiGIK4pQGe+XtLGZB8vreAc4D7
         KYIzIimGfJxbRmBbQaYjKnC1BjrkDhD36/O01QkPZRxJSKbFvX/An3FsR4fzbJIvmw63
         kpfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZHscXVDnqtQcuqFlK/F2h4eSbihIIcX+F66112PRak=;
        b=FZE+ZTCzIy3BcOEBZ7tFNgW0xJincPxUqDNcOWqyw5zZArb/v3wlXS0xCDdDFy7SSN
         RBg+LhiLo/N6I57g1lBXK14w7WOG2aoGvMwa/+TTITjp7VHeeM+7Baz3La7Jgyo522PB
         XWDYJi+BhFBtpBN06JpXC+KnooASr7rwPnWdgwpFR7204HMvmLYKw1wQzS3p2KpDF8j8
         byQtOGR0ry1Jw4AY+UZgLAjQh59M25dzBM7g6FIH1IPu2K24duQV7v9gxG4XGdhNMfcK
         QVv/i9rtgAmM85Zq8mDCRI0/0MH+6w2ztGwi+6KPVcY6eo0AmcItnjrYizhvqVJ9Ap6L
         67hg==
X-Gm-Message-State: AFqh2kquTKgjkRFPfBHhhfraws5kmW8mY3yvr5dsfYxEhRhVnjxeelWj
        N84F3zOdtjRiqS/Dy6HmDxnUwIuwCT6DyPqf
X-Google-Smtp-Source: AMrXdXt5HKli+kreiaQki+fO40lDVz0EbIvYIgsqObYa2QC+eqNzqqsL8OnHWiEiq4taHwZ/cZVFrg==
X-Received: by 2002:a17:90a:9917:b0:229:22c3:5a9c with SMTP id b23-20020a17090a991700b0022922c35a9cmr3534375pjp.3.1674232624064;
        Fri, 20 Jan 2023 08:37:04 -0800 (PST)
Received: from ?IPV6:2620:10d:c085:21e1::116e? ([2620:10d:c090:400::5:fb81])
        by smtp.gmail.com with ESMTPSA id mm17-20020a17090b359100b002298adf6edcsm1746454pjb.13.2023.01.20.08.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 08:37:03 -0800 (PST)
Message-ID: <a701d378-2bd2-3410-6e3a-20d41fcc6608@kernel.dk>
Date:   Fri, 20 Jan 2023 09:37:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-6.2 2/3] io_uring/msg_ring: fix remote queue to
 disabled ring
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1674231554.git.asml.silence@gmail.com>
 <845f25277fd30f80ecff4a1352bb10739f300b28.1674231554.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <845f25277fd30f80ecff4a1352bb10739f300b28.1674231554.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/20/23 9:21 AM, Pavel Begunkov wrote:
> IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
> it's not always safe to use ->submitter_task and we have to check if
> it has already been set.

As per private discussion, can we just forbid it in general?

-- 
Jens Axboe


