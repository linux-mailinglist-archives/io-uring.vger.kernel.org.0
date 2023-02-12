Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402506935A6
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 03:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBLCnB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 21:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBLCnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 21:43:01 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321A612072
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 18:43:00 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id h4so2567108pll.9
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 18:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UfPAAizyWDulL2u7Q2gwUlbheSEUoxiWrAgxbmEozdw=;
        b=S9v89PAwfzJ9i3HK+mpa22SkcgGOruKCno5xUY7LdRAQYD9/RAhfjs7Y4zPgi4OWfl
         QJFn/wPJAAOGB6Hc1/hB3DX4m1djYwIuBdVdjMbY+kpaOeZIpZYPIhjLsq6he0Q+fwz9
         uGXZZ9UyxfJvy2v8IHZFTISSoI9vq1VKMBUWGYJtuV6oj9YV2nw8yh601Uf9oxbCb8YW
         sSygJjL5JcXzp6Byj9g1m6UovzXLCDEpfZu6VOyVGYcN1D0lywpFdVOQq7s2l7/YKEbg
         wCJFTiteG+eTeBezKPKYx7/RSQ5pvKHiulRBcrtOUPdXfj44zq3MK9I+3twUrtmFiaEN
         vMRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UfPAAizyWDulL2u7Q2gwUlbheSEUoxiWrAgxbmEozdw=;
        b=ORtLrbkriuMD6qMWiJ/jEVoXPEA+jkQgEpwZ8Fnkg6pyB8V0+EzKwNhoDbxNtzb1yR
         1+NGagLMQxAmf6oGG5CJQD3LVJzT0X81yZ/Ci+VUcfHZ8scubJM/zMAbpts3scHBPamL
         yhiD53BC25KRJIhlE5s/7x4s2ArxFUu5oKxh/61y17TEcVMsKhO5KC1Ky/l2sPPnn6Si
         Pl9JF5qfhm3MCl0ckHuSlZWSSAlwWcpC4OtIGEZ9WZLPyz4mteQ7fk0waB2N6b0gNSeZ
         j70pyznvm7W+h0V5vilMK+Ts4zWa5FVDR03CUv3lJxMEzZhD/7BRSaQUL7mfR7ot1d+s
         c9DA==
X-Gm-Message-State: AO0yUKXVnxc5uEjyuRd4MDCPdg43ZFmOKDqdT477s6eZd6uBXc0xNtRB
        yOZzVwRtffndJFn8Bp5X3+++PA==
X-Google-Smtp-Source: AK7set/4Vk6cZUn5nHnuAXm1aWHB6Xqz0MDzOiEtJ6oXCErcbU7r2r/jZJRmeCbNwfB9H2LKG8ayww==
X-Received: by 2002:a17:902:d4c6:b0:19a:9864:288c with SMTP id o6-20020a170902d4c600b0019a9864288cmr555380plg.4.1676169779387;
        Sat, 11 Feb 2023 18:42:59 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902eb1100b001947222676csm3608939plb.249.2023.02.11.18.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 18:42:58 -0800 (PST)
Message-ID: <409656a0-7db5-d87c-3bb2-c05ff7af89af@kernel.dk>
Date:   Sat, 11 Feb 2023 19:42:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 3/4] io_uring: add IORING_OP_READ[WRITE]_SPLICE_BUF
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
References: <20230210153212.733006-1-ming.lei@redhat.com>
 <20230210153212.733006-4-ming.lei@redhat.com>
 <7323fbef-4790-3975-9c43-7ba4b7809c33@kernel.dk> <Y+hFZaFte9YyfVwR@T590>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+hFZaFte9YyfVwR@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/23 6:48 PM, Ming Lei wrote:
> On Sat, Feb 11, 2023 at 10:13:37AM -0700, Jens Axboe wrote:
>> On 2/10/23 8:32?AM, Ming Lei wrote:
>>
>> One more comment on this.
>>
>>> +static int __io_prep_rw_splice_buf(struct io_kiocb *req,
>>> +				   struct io_rw_splice_buf_data *data,
>>> +				   struct file *splice_f,
>>> +				   size_t len,
>>> +				   loff_t splice_off)
>>> +{
>>> +	unsigned flags = req->opcode == IORING_OP_READ_SPLICE_BUF ?
>>> +			SPLICE_F_KERN_FOR_READ : SPLICE_F_KERN_FOR_WRITE;
>>> +	struct splice_desc sd = {
>>> +		.total_len = len,
>>> +		.flags = flags | SPLICE_F_NONBLOCK | SPLICE_F_KERN_NEED_CONFIRM,
>>> +		.pos = splice_off,
>>> +		.u.data = data,
>>> +		.ignore_sig = true,
>>> +	};
>>> +
>>> +	return splice_direct_to_actor(splice_f, &sd,
>>> +			io_splice_buf_direct_actor);
>>
>> Is this safe? We end up using current->splice_pipe here, which should be
>> fine as long as things are left in a sane state after every operation.
>> Which they should be, just like a syscall would. Just wanted to make
>> sure you've considered that part.
> 
> Yeah.
> 
> Direct pipe is always left as empty when splice_direct_to_actor()
> returns. Pipe buffers(pages) are produced from ->splice_read()
> called from splice_direct_to_actor(), and consumed by
> io_splice_buf_direct_actor().
> 
> If any error is returned, direct pipe is empty too, and we just
> need to drop reference of sliced pages by io_rw_cleanup_splice_buf().

OK thanks for confirming, then that should be fine as we can
obviously not have two syscalls (or sendfile(2) and task_work from
io_uring) running at the same time.

-- 
Jens Axboe


