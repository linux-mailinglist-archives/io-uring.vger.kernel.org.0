Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD939166993
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 22:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgBTVIl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 16:08:41 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38710 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgBTVIl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 16:08:41 -0500
Received: by mail-pl1-f195.google.com with SMTP id t6so2030057plj.5
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 13:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rdBcwe5Vph94eHebPStaIHe72ziYlvFbYfO8t9TWJwU=;
        b=yKTaUD6Z5Ug8wx4kusdDtAkdqeVA5TPlGO6J+KPhcfD7lCS/QaZ02TlECQocfBNyDR
         hVy3AkJ8H/EKmPORJugatcuknmTWwq1xyjsWtKBd5tTr2fsud3YwLlcDOv13yUxqbtuk
         ApA3c9wU6vpZBFOU5NT+s7h9+CWwt4YDF3iU4I0r0UHRX/JeKK5rRdZ7VltAJqukCloE
         X+9LreL0Myaz2yWtucSpig+ol3+X8BVVz0ZyH2VePLb1XyTrP5DSdl4daEqLKN7vnnZ5
         Dol5uWn/w+aZGDo9gxtQXAN3MrbIWogatFoMGx5zcdiHNA1njpUOizbTShk6AswJ0Wfu
         ICgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rdBcwe5Vph94eHebPStaIHe72ziYlvFbYfO8t9TWJwU=;
        b=MDzn3VtyOrJOIpTnGCW3Xdkoz6tJSF8IFP3Mh0OUKWQNdBjq8GKOqYQztmYAIWPCQN
         pG1viHP5Gej4IjBzLC1hNTUbDxGrzIOYuGKXpe6X0MGlP7l2P220eoy8fDrH6RqsI3O2
         LwcTN9fZZcE5JMnLHvwCmPk1tjPfSkqU1M6qaPOqWuQvr2svulCwTuZ+zyBkhtdh9KhU
         GmIVGZotPC8tVq+nHKaLzWvbZNW2BcZRlPtqH/DaYlE0nq5GbcljDBniQBxtSHghHuhD
         XDejF7esPFWvqP5EShbj3E3HNY8jUMVSIdDlNt/aDae+6Gz1Tx1Zrvy/qKV0dsK4qrM1
         Wqxg==
X-Gm-Message-State: APjAAAWt3T6AUSIQoDlZyKNwyMud7G5LJckIlJSG8oRehCVb841eTQke
        c/BWBmmigbZCXY3/UAoMunPhJ/caOew=
X-Google-Smtp-Source: APXvYqwZRH29s7Whf9Fjut2/NG8g6z/L6pvDJ6Vk1TBtgHpzS75mX2aqENGpl/gnsrQObYcxBx65NA==
X-Received: by 2002:a17:902:6504:: with SMTP id b4mr32828599plk.291.1582232920631;
        Thu, 20 Feb 2020 13:08:40 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:8495:a173:67ea:559c? ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id b15sm494717pft.58.2020.02.20.13.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 13:08:40 -0800 (PST)
Subject: Re: [PATCH 5/9] kernel: abstract out task work helpers
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, glauber@scylladb.com,
        asml.silence@gmail.com
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-6-axboe@kernel.dk>
 <20200220210731.GM11457@worktop.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <59854fa6-d4c8-9eab-a624-7033612e1d8a@kernel.dk>
Date:   Thu, 20 Feb 2020 13:08:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220210731.GM11457@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 2:07 PM, Peter Zijlstra wrote:
> On Thu, Feb 20, 2020 at 01:31:47PM -0700, Jens Axboe wrote:
> 
>> @@ -27,39 +43,25 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
>>  int
>>  task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
>>  {
>> -	struct callback_head *head;
>> +	int ret;
>>  
>> -	do {
>> -		head = READ_ONCE(task->task_works);
>> -		if (unlikely(head == &work_exited))
>> -			return -ESRCH;
>> -		work->next = head;
>> -	} while (cmpxchg(&task->task_works, head, work) != head);
>> +	ret = __task_work_add(task, &task->task_works, work);
>>  
>>  	if (notify)
> 
> 	if (!ret && notify)

Good catch, thanks! Fixed up.

-- 
Jens Axboe

