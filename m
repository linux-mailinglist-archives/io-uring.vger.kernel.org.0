Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA410159A81
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgBKU16 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:27:58 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45209 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbgBKU16 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:27:58 -0500
Received: by mail-il1-f193.google.com with SMTP id p8so4603887iln.12
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EwbwOOwq9gLshNcKlJTOmHmIxHcN4l6l6Kx18nKll7I=;
        b=or15VYXI+draQwY5YG38LhLzHlsPx/mEIart1rP2CtTIIt/jQu8KkprWxhtRG6byac
         uQboyytNzosHOrbB+fROa2WY/MJg+oXAojBbXZPy84V95wTIhFXUbTJhdcxZiX8/4pj2
         yemvSu/Lc2OKKEFNHOokWrzpgsMFPGO1pHafIQsoCjmjQRsBqMomUMUgxhsEDZfCRpbt
         bGl39dz/n69JcE/xLQNcDZCdIBzoqCf+iJ1UpFhETLx3MmAMb5yHvnWNP81Vm7LLlJlQ
         boVJ+v1wqgIEY/Hzr0+2grdDdExMt5UZcbpZM/tbDtWbPXZ2QfnjnN0neQo4rZYopMwK
         cEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EwbwOOwq9gLshNcKlJTOmHmIxHcN4l6l6Kx18nKll7I=;
        b=P2w4HicYGNaEM7IdCQIdyKsPw6b3fo7SfZqA6OZy99pfOGM2miSlkzd1pTsAjYVWAg
         nmyhng9rLyaHnyIx0GY3dlz2g2E2xFqhW/jg4vw9TMOOtVWyfZkkLg5wDgs8QjvQXly4
         XTOp8u3LZUIn/QXsA4JxoAniIy/krqqLePN1zD8PD/zdXb2Lhb/LnW7f59OhXKAPFbKA
         UAQOF6bUCBTRDiWb874lc+wyfAXCLonY/5bcnGWgBWcQpgTBTAILfofa8STXaxwT3pb6
         ZaZVhy+ozKHdZdVpxwCDVeW1EP+dUCLpTksTXQaKq3+YnvyuYalWpdQvlJ35kREDkLhl
         clqg==
X-Gm-Message-State: APjAAAVD0qd+l5XQQmJDXLzHN4RbgTCTXB7etXWENSQwLKLFEueSzPqM
        Cim6Ukb/K3wso2hXfwcQkQVCfrks5wI=
X-Google-Smtp-Source: APXvYqzMughh6fisfwMw7C331JIfWJdURChCdD1n5likyvHLbFNPW75JJW8xHGXeQCOJiC+fk62wzA==
X-Received: by 2002:a92:4013:: with SMTP id n19mr7946633ila.279.1581452876177;
        Tue, 11 Feb 2020 12:27:56 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q1sm1610196ile.71.2020.02.11.12.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:27:55 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: allow POLL_ADD with double poll_wait()
 users
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20200210205650.14361-1-axboe@kernel.dk>
 <20200210205650.14361-4-axboe@kernel.dk>
 <1fb14ecd-4a2b-2eaa-97a5-d96a1fcc6aee@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e301838c-b9d3-45ea-85ed-a2f08d455c09@kernel.dk>
Date:   Tue, 11 Feb 2020 13:27:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1fb14ecd-4a2b-2eaa-97a5-d96a1fcc6aee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 1:22 PM, Pavel Begunkov wrote:
>> @@ -3692,15 +3738,33 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
>>  			       struct poll_table_struct *p)
>>  {
>>  	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
>> +	struct io_kiocb *req = pt->req;
>> +	struct io_poll_iocb *poll = &req->poll;
>>  
>> -	if (unlikely(pt->req->poll.head)) {
>> -		pt->error = -EINVAL;
>> -		return;
>> +	/*
>> +	 * If poll->head is already set, it's because the file being polled
>> +	 * use multiple waitqueues for poll handling (eg one for read, one
>> +	 * for write). Setup a separate io_poll_iocb if this happens.
>> +	 */
>> +	if (unlikely(poll->head)) {
> 
> I'll keep looking, but I guess there should be :
> 
> if (req->io)
> 	return -EINVAL;

Yes, I've changed it to:

if (unlikely(poll->head)) {
	/* already have a 2nd entry, fail a third attempt */
	if (req->io) {
		pt->error = -EINVAL;
		return;
	}
	poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
	if (!poll) {
		pt->error = -ENOMEM;
		return;
	}
	[...]

-- 
Jens Axboe

