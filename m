Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB67537ADB
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 14:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiE3M45 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 08:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbiE3M4v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 08:56:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E2D63F5
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:56:50 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso10703351pjg.0
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j0L7y5bj/YrgOhWayzhHRrX4WAk9LBnc0Hf4ZhqCfuY=;
        b=b+9sXFBBeYbpXYD/tHQ4VxZ4iBgQuu3ebkFZet0zQWUrZcGCwgoliBz1iC5uOQhCkc
         SzyUsz+qZWa2Tos16mqlZ1n5lWUNlZxFSChgq3tsZF/QaBGc0aPGMZYxXDYDi9JvL+js
         NT+pHbH4F/wIRKIAZsnEmlhOejsougy6PIusUb9+DnXw+9KEfh/ZhoTBFEFAqdyCWNfh
         YOrw+hqdMIs5MIROG/hE/dV2NYHDwYdWRtnRn8UW4GpPt4KhtRN/PSap5eIbZYAUaIi8
         XqPSC3VGA8ALXHf4gKGk/vu7nDjGoy+HrnsasJKVqFQtEYvE9ZT8vJnfyX9q487RaTBP
         UJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j0L7y5bj/YrgOhWayzhHRrX4WAk9LBnc0Hf4ZhqCfuY=;
        b=wKDfWmzdpDyxvD49KyEKHzfYaM3PImKvlV8VzsI27KElH/vRGXyvYH8W2ZkQHIbagJ
         MItILyRycN/pos+Va1hGhY967sTv+VnlJq7N2J2jVU3RI42I4mYapbKBw66v8BuRheU5
         FMWRk5xjgGypAbQc/8MYw0guC3+O95SIeeOSFuK5Jw+ubuvRg6PPdG+BN4fSB8bqT+NK
         nI1Q+LH2155vLR63E42FtCTr1gQ1Er3i850e7R+Tl+FZu3itKAt6DzvWPjVwKV7mqyX8
         2ypwmCDipL0UQXVnDFTMSrymvq1E2lYN+mEYQJfMB1fIQzqWLn9y2VmiKR2uJqaCj+zC
         t/pw==
X-Gm-Message-State: AOAM533VNDdmK6uCAs77oWh1ko2cna7kCwa5hQfjh4b5Ajysd8zHrQc3
        aHjrGlgJISpW5BP0SJ0h/os9M5ZsAxXTAA==
X-Google-Smtp-Source: ABdhPJz5Cm+h6MI4XSiBHroiB5BcjsWJNNbE9u9M/Y9sW864inWac/R1rp2YmrgQ7tOuU69QxsT8rQ==
X-Received: by 2002:a17:90a:b88:b0:1df:2b03:20c with SMTP id 8-20020a17090a0b8800b001df2b03020cmr22983113pjr.46.1653915409439;
        Mon, 30 May 2022 05:56:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h6-20020a654686000000b003db822e2170sm8544514pgr.23.2022.05.30.05.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 05:56:48 -0700 (PDT)
Message-ID: <8461f907-58a3-eebc-c7ab-0c55a62f55dc@kernel.dk>
Date:   Mon, 30 May 2022 06:56:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530124654.22349-1-xiaoguang.wang@linux.alibaba.com>
 <ce0427aa-291a-c42a-02c8-7e80ec978f1a@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ce0427aa-291a-c42a-02c8-7e80ec978f1a@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 6:54 AM, Xiaoguang Wang wrote:
> hi,
> 
> Forgot to add "Suggested-by: Hao Xu <howeyxu@tencent.com>". If this
> patch can be merged directly, please kindly add this, thanks.

Please do a v2 with the flags check I mentioned, that's definitely
required.

-- 
Jens Axboe

