Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047D11A1072
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 17:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDGPns (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 11:43:48 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:46252 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgDGPns (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 11:43:48 -0400
Received: by mail-pg1-f179.google.com with SMTP id k191so1888869pgc.13
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 08:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FQNNtUqT9JMBz3XRgTYZLJtjwpnxWx3jjF/AUinXGGg=;
        b=tUDoUl+dyI/+SMFxAJcfxjdsNRPKkQZIjvfueS+D/XocGtSaluEdQhbej040NOOmY1
         8fpKsi5iwtrw6E4BGRyvwtB/d838wdz/q6MsQGQfquue8+iYR4y59YK/AzpKrK6A7r1X
         4KG4ax07IQND56/OMq9GlMJ0PYhUNPB194oJ99Es2AtfUzFCxMcGJdSxpGlmzzC0Y1O5
         sw5/Cmna12MFrbraG2854m+VaJTD4ViFumtzhWHf3PgvQGpMDUfCAFRgfgSECrG7Yy43
         G5MqcSJSfR4LZJnOgNWE1OGi+PUFSHN4CM4cV/K6Ni/PqfVWmjhtVnkhmdyVDwNTUTcc
         l9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FQNNtUqT9JMBz3XRgTYZLJtjwpnxWx3jjF/AUinXGGg=;
        b=j+aRyfID5atvK41xjLPmm2tDjjGoji6DSFfSLO7K9VN0hxmVu3s7XSiI9sTunuBYhl
         Acf6iLu7LXn+I2gnfyuCUd1nUTNP9kozEfyHnMCiChdtoJSWVVkHHKXoFCPSxJzuGiT9
         gxeFpdrNPxoAPMTxYlw1tG/wcWUjMLtw+qImIAnKTLT2foNWjq/8ZmsYbgwrEjPAMVE0
         mXQ2cQs0twQQfwxBqpsmDvNWgpK5FH7nPf5dbets0nchSzR4xVp4PB8qlhqkqJXFflVo
         Mf7/y8Z1ii/bqM1ASKPI8CkLvtmsz4IcMDq0404McA+WgL0KOQdY7nq/efaRwBAq/diC
         9xtw==
X-Gm-Message-State: AGi0PuZeDeIPoIuvqvnKmpFa9ivHSD4vNKSzPJYhaHPWFIQc11AT1RjQ
        AgtUymXnhEd4pWZM/Vw/zSgVVw==
X-Google-Smtp-Source: APiQypJ/6RWzhbd9gRcLCPBT3PlzO7sTOQhc0LLrKqEBmjKDPwNIakCs8cladoO97QswLL7NFvw5qA==
X-Received: by 2002:a63:1053:: with SMTP id 19mr2739797pgq.60.1586274225398;
        Tue, 07 Apr 2020 08:43:45 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id mq18sm2179520pjb.6.2020.04.07.08.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:43:45 -0700 (PDT)
Subject: Re: [PATCH 1/4] task_work: add task_work_pending() helper
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, peterz@infradead.org
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-2-axboe@kernel.dk> <20200407112833.GA4506@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7f6da54a-a707-0a98-204c-90cddbe62aeb@kernel.dk>
Date:   Tue, 7 Apr 2020 08:43:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407112833.GA4506@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 4:28 AM, Oleg Nesterov wrote:
> On 04/06, Jens Axboe wrote:
>>
>> +static inline bool task_work_pending(void)
>> +{
>> +	return current->task_works;
>> +}
>> +
>> +static inline void task_work_run(void)
>> +{
>> +	if (task_work_pending())
>> +		__task_work_run();
>> +}
> 
> No, this is wrong. exit_task_work() must always call __task_work_run()
> to install work_exited.
> 
> This helper (and 3/4) probably makes sense but please change exit_task_work()
> to use __task_work_run() then.

Good catch, thanks. I'll make the change.

-- 
Jens Axboe

