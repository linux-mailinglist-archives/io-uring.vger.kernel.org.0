Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7D3E4B18
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 19:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhHIRsA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 13:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbhHIRr5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 13:47:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946A3C0617A5
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 10:45:27 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n12so12458388wrr.2
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 10:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+Y9yAdTcxdG9J2zbffK1g0mGtahch7THKnbMknkmJe4=;
        b=u4PtkWJNxuAq2OA3unVuHAQZsPhx47HdYHiEPz40azMCpzo7xH2AB2e2Ed5OaqfGDw
         CUR/cHe4+lc2ouLTHFda+h2a1LGW9J0q/eSgnrZJdkagosHkRCa6sOakSlBfLTf4lMvG
         s6PqI2XAJs6+kN5Aoy8ldA3vXgQoBuJaI3ZCRSxnX6x7EgsHvWKl7qFHjE3GLHwtoBk4
         LeE/cDAg4BICQlX5VTkw4c99RQllGNWySW+2+DZvYP5RmQ4XwRHCyUSRE0TXlSQujqhe
         SbyRTnzsobrkvZ7fbN56WgtsHc2VSplznkG6ik/jsmxvEPOx27Qhy1RsKkudREZETrQf
         tJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Y9yAdTcxdG9J2zbffK1g0mGtahch7THKnbMknkmJe4=;
        b=iGpmWYFynsH9M9D5elciZi1kfAd95Y69ZtnH/QfJK0eJZHtYUnZDYZ1687W3d5t8R1
         p+5/QNBloiIeIgtCy06XocmhDB6E6WGngFwPK4Gb+380IQaY0C52XBe17/P/bve4HLZz
         GfY/zz3/BNwLoEwowk2ZeDBmQyN9MGNFFIvFuv6bP8BS/Ax6bXamS+wHKF8XWsrCLvp8
         ku0KBfPxVVQoMfvOaeuEmXts0YgYKuo/4GA/rpVjwCR9u+0zyY2WEqt66lSFnZSTFzHU
         3WMuEr3a6QFyh+shliaR7A5+l6Ye+JzigM4xngBsbQQjmLDZ6Lhaj9WKLDV05g2MtBDr
         MpbA==
X-Gm-Message-State: AOAM530MLZTarYAA4H63nAVaGJUzDMQ8vP6p2NTYHYFzzdwL1Bg18hrT
        6YrARGU/SPiQP47ZtTMjXCSA724KysQ=
X-Google-Smtp-Source: ABdhPJzNO0P4h4oSFPsry9Y3opEgjqFOwmxvt3B9HgPmcdAw71Y0GZDmQ0/8TL0AAMJSYK8JnyCH0A==
X-Received: by 2002:a5d:6a4c:: with SMTP id t12mr12775806wrw.412.1628531126090;
        Mon, 09 Aug 2021 10:45:26 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id w14sm9336159wrt.23.2021.08.09.10.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 10:45:25 -0700 (PDT)
Subject: Re: [PATCH 21/28] io_uring: hide async dadta behind flags
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1628471125.git.asml.silence@gmail.com>
 <707ce8945e0247db7a585b5d1c9e8240a22e6708.1628471125.git.asml.silence@gmail.com>
 <4603a964-2812-64ab-8236-ea897f610a83@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <29ee7750-3a6c-f1f4-7ac2-6c2e4d94c526@gmail.com>
Date:   Mon, 9 Aug 2021 18:44:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <4603a964-2812-64ab-8236-ea897f610a83@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 6:30 PM, Jens Axboe wrote:
> On 8/9/21 6:04 AM, Pavel Begunkov wrote:
>> Checking flags is a bit faster and can be batched, but the main reason
>> of controlling ->async_data with req->flags but not relying on NULL is
>> that we safely move it now to the end of io_kiocb, where cachelines are
>> rarely loaded, and use that freed space for something more hot like
>> io_mapped_ubuf.
> 
> As far as I can tell, this will run into an issue with double poll:
> 
> static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head, 
>                                  struct poll_table_struct *p)
> {                                                                               
> 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);   
>                                                                                   
> 	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->async_data);
> }
> 
> where we store the potential extra allocation, if any, in the async_data
> field. That also needs to get freed when we release this request. One
> solution would be to just set REQ_F_ASYNC_DATA before calling
> __io_queue_proc().

Indeed, good catch. It appears the end result of the bug is a leak


>> @@ -3141,6 +3150,8 @@ static inline int io_alloc_async_data(struct io_kiocb *req)
>>  {
>>  	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
>>  	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
>> +	if (req->async_data)
>> +		req->flags |= REQ_F_ASYNC_DATA;
>>  	return req->async_data == NULL;
>>  }
> 
> With this change, would be better to simply do:
> 
> if (req->async_data) {
> 	req->flags |= REQ_F_ASYNC_DATA;
> 	return false;
> }
> 
> return true;
> 

-- 
Pavel Begunkov
