Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551C253822E
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 16:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiE3OWQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 10:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241370AbiE3ORc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 10:17:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA1B8FD78
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 06:45:52 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e24so2354530pjt.0
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 06:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=w3M/GJfn5feneSDKVYXgVpagFclgBQX/nWmW9Bfo9MM=;
        b=51Epuf3/2Gr7tkxMqA41GP8jEQeA0rPHNjpMy0iBEyAppmxeHmaZln5xturUpwFif6
         8x2MALmBXeOilqtSPRSNFAopB1QMdRztDyjgP6eW46Mw77DDK4lFkcQEXEvMhRxj2qSQ
         aL0AXZUhWjKyNz+8Mq0UQrHX7S4Z+zQYT41QgeBrbXiIsJ2TzF8KAqxobOlYRBTPDgE8
         EJgAhJyWRVtyt1tHzYUbps22zcK7ix1xqXGFncYB60gTrWUP29wYVKZEAuBATuBanTUV
         wF7PQ5HyJnrXC7AXgubUU6P7f5by+flCPS75VgOc2UAcbLrDXvcMpcicrP8VAmfHYIbM
         7pAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=w3M/GJfn5feneSDKVYXgVpagFclgBQX/nWmW9Bfo9MM=;
        b=FVSDK45Xcfgz7pssM9AStT2FfV4n/QJ/oZPMW29PhO6yzPLxxavl8RuMp/WmrKaMZt
         E8rZpCnIfoXgZGU+6vhOY5W7E17NH0KdOEIxNdqqIkE7yPtqVoeZOPIq5HhCg1Y06ONs
         PPaRLfc6di+KCmyipQKXhp1+O8ZA62z5NhwhDcmYBxChyluVbwJgkH/9u2wCLfVimkAv
         sLhn9BG0qvZRuhtu6axdnaG7SKMHkkaQBxArQpA8ILogFyYfzI865C3DQnTYfSro//he
         l+PA6QdQmwQ8sSpTfIYlRNvyBMw85ZLQB6NoC572d2JwHryWdQMYBqAGZZPXLWQ1dRom
         AbIg==
X-Gm-Message-State: AOAM53171kDfqZRDxDH2NJ0FlYp7BiNtmGw9lzaUlO35tPtrKY3GDcsO
        cholKvqpj6ar0+CR5WkPZ+J63g==
X-Google-Smtp-Source: ABdhPJyH4M1K5Ui0ipeMOM8jm69yPuRzz+ry9y4tHd2U1HFQQiC942a8F7U8J+DsRXxDalwWpVolKA==
X-Received: by 2002:a17:90b:1bcd:b0:1e2:c8da:7c29 with SMTP id oa13-20020a17090b1bcd00b001e2c8da7c29mr10175952pjb.4.1653918351940;
        Mon, 30 May 2022 06:45:51 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v62-20020a626141000000b0051b6091c452sm916467pfb.70.2022.05.30.06.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 06:45:51 -0700 (PDT)
Message-ID: <08f2395c-50b2-850a-0ce9-583be34017e3@kernel.dk>
Date:   Mon, 30 May 2022 07:45:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530131520.47712-1-xiaoguang.wang@linux.alibaba.com>
 <3064f1e4-c66b-a90b-8073-dc63525c5aca@kernel.dk>
In-Reply-To: <3064f1e4-c66b-a90b-8073-dc63525c5aca@kernel.dk>
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

On 5/30/22 7:18 AM, Jens Axboe wrote:
> On 5/30/22 7:15 AM, Xiaoguang Wang wrote:
>> @@ -5945,16 +5948,22 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>>  	return 0;
>>  }
>>  
>> +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
>> +
> 
> This should go into uapi/linux/io_uring.h - I'll just move it, no need
> for a v3 for that. Test case should add it too.

Here's what I merged so far:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.19&id=f6b0e7c95c20d4889b811ada7fc0061e8cb4e82e

Changes:

- I re-wrote the commit message slightly
- Move flag to header where it belongs
- Get rid of 'goto' in io_files_update_with_index_alloc()
- Drop unneeded variable in io_files_update_with_index_alloc()

-- 
Jens Axboe

