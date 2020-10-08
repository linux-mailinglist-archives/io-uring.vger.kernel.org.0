Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8696E28754C
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 15:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgJHNiH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 09:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729795AbgJHNiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 09:38:06 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D7AC0613D2
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 06:38:06 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t18so5674997ilo.12
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 06:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b93Kc+xY+b7cH8cB6lbTNiPo6n0tl8gLa+1bBQM6ugw=;
        b=cnh7MTwVgm6hZzQjxK8sAL6WRlDnqIuThSj0ignSSSQwCVT8mS1ZAYa+NmdWqevm34
         KGIoSxYEdeMBLJQHTeE+/LJGjgH22V7GRY9KQqqdt36dLXqbBqOo01XvcQGv9DtxVyD3
         u2pbO/KrfWrLdDTk1umAxRRclbS1ODmeXGT2f5M+YvIy3Vk35/e14FwDMIk2UX+hkESu
         CPKTgR2XjckfLNXVTwPT6TPAl4CcBRC3eQXZXprBwqVnZ4qfb6+e7s7MFc1B2Nk+Kcf8
         jubWIjBRy7ByyVHduIFzGE6DWmveQ4T2a1dDjV9vU52xDtQ7TWgwNK40x0gIUD7O0x2F
         7TEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b93Kc+xY+b7cH8cB6lbTNiPo6n0tl8gLa+1bBQM6ugw=;
        b=SKCQ2oS6rD+g7VvGHswcjK5HWPSjRHCOoBvT+dV3m1UTggwIV+dl9E0Z5Ts2CBzmPG
         96Rmpjgqj1fXvmeg+IOfOCyyEY3LGzVpczP1ieLH7ahT6REciv/It9llxdCeN3sCvNw6
         WRNkYkk/ARO7P/ARDvWNYF53j4GyEg90AYTQ+t3grJjmVqmz8ErQBdZL2PRv8JtmvTbK
         zlJCzpsqeJLAAD5t2MGkqGxEGwa2Nlj75GUDEvRB1UP2MJIH/D3ARxk4K9NG1k6osQLy
         Qek1NlmhvPxImz/6YVFoyyI9Cixm4JSCQRBc6TXgUxGBEURrXbAqnBxzGuWQ7fMAJFyI
         5aCA==
X-Gm-Message-State: AOAM531/YRRx5Td/41SggqWxr5c6aJat7ogKGTv6m8uU1fUS/CAueZ87
        XL5cbYvQi969KbBSpfEleTrPdA==
X-Google-Smtp-Source: ABdhPJym8GZtc9ZvMH8uYzSrnQH/iVbhewZCWj/fnI5QjZuxNfVwDnqwGk22bAGIJ4ZOYM/kWY1Qng==
X-Received: by 2002:a05:6e02:547:: with SMTP id i7mr7125661ils.0.1602164286062;
        Thu, 08 Oct 2020 06:38:06 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v13sm2643955ilh.65.2020.10.08.06.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 06:38:05 -0700 (PDT)
Subject: Re: [PATCH 2/6] kernel: add task_sigpending() helper
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-3-axboe@kernel.dk> <20201008132444.GF9995@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <99b7ebb1-0cf8-7605-bf2f-08e7abc9cf43@kernel.dk>
Date:   Thu, 8 Oct 2020 07:38:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008132444.GF9995@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 7:24 AM, Oleg Nesterov wrote:
> On 10/05, Jens Axboe wrote:
>>
>> @@ -4447,7 +4447,7 @@ SYSCALL_DEFINE0(pause)
>>  		__set_current_state(TASK_INTERRUPTIBLE);
>>  		schedule();
>>  	}
>> -	return -ERESTARTNOHAND;
>> +	return task_sigpending(current) ? -ERESTARTNOHAND : -ERESTARTSYS;
>>  }
>>
>>  #endif
>> @@ -4462,7 +4462,7 @@ static int sigsuspend(sigset_t *set)
>>  		schedule();
>>  	}
>>  	set_restore_sigmask();
>> -	return -ERESTARTNOHAND;
>> +	return task_sigpending(current) ? -ERESTARTNOHAND : -ERESTARTSYS;
>>  }
> 
> Both changes are equally wrong. Why do you think sigsuspend() should ever
> return -ERESTARTSYS ?
> 
> If get_signal() deques a signal, handle_signal() will restart this syscall
> if ERESTARTSYS, this is wrong.

The intent was that if we get woken up and signal_pending() is true, then
we want to restart it if we're just doing TIF_SIGNAL_NOTIFY. But I guess
it can't be 100% reliable, even if TIF_SIGPENDING isn't set at this point,
but it is by the time a signal is attempted dequeued.

I'll drop these too, thanks Oleg.

-- 
Jens Axboe

