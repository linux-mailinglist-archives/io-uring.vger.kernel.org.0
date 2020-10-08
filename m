Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87CC287547
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbgJHNgQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 09:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgJHNgN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 09:36:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD73C061755
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 06:36:12 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id r10so812965ilm.11
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 06:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e7rKdhz9ciQ35grcxHtJq/vbArd/VYg41u1IRyoy8VI=;
        b=HfGsbetB6A3geRl7IVm3II/NsMYKjFCFSFfoj1iukhJmepiTMLgPiaDn5YGf4i9jz2
         TqzIuKIFdAe11i4HznOu927mFEkzbGbAUlRPOXKK0LtJT4hLAcZdpODNOt9fOtxaUhQv
         k8uAtIVRYHNJi7p8BAWiPjXYOwRdIKTL5bHK+Yzu+P77q2eQzbDsVgeJPVl9KUe5cIF0
         MmGOb6XJUvNH96DiwSkhKRHbINUNOs3sRNpDrKBQkzU5TGoao/lz8X24GZjZWS/F1Ft6
         it2raX3dGmumll3aktLzsGWbzLAgFFLyoH3G7uz0iKOpx01VF03O90IU0ZFs2adTgnvV
         SVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e7rKdhz9ciQ35grcxHtJq/vbArd/VYg41u1IRyoy8VI=;
        b=nxV5fz71nQXDPIOlIzGTn6zhloejnnMIc/zO6zrXWyySVDf4MQzbqWjT4FjZ+2IxuA
         9QII8BpmZoaKMmRk7eI5S6lgaD1dVZRedTUkjd88sC77tjEUGp1g+Vql0c+1XSNlZbOV
         4PLV/nh5jetKWUP+fRFMOT1cqq8MQeRKdZfw0Gw3/Mi3qu0HIRSTv7uiINv921NDcxyJ
         V9t6dsIDLu0c31ISkJMzf3PUG6jQ1C7/A4FJFOgTyGDOHBxAiMiUYXJZPUfOX5UmQ5jA
         4jt4NvQWi8pZZn/fmJe6juv1GHgMO4bRzc5Jh8Ksa2OVmQvnHn5BzIzYm17CQzXCGZUN
         EhrQ==
X-Gm-Message-State: AOAM533NCgVnb1PpI6LlqCZip8xhQd0yA2+/CyXfgRcMqGsc82IfSpbk
        V3G6Kql6e89ntwwNGt6vkZopEMposQp/9w==
X-Google-Smtp-Source: ABdhPJz6tDDYK+6C45xazMybLC2eN+4Dol/Z1XWOgrGCAjKxpHzNLZq/+mSHZoSnPk7k+mx1rgBKMQ==
X-Received: by 2002:a92:2591:: with SMTP id l139mr6902795ill.271.1602164171318;
        Thu, 08 Oct 2020 06:36:11 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m10sm2636882ilg.74.2020.10.08.06.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 06:36:10 -0700 (PDT)
Subject: Re: [PATCH 1/6] tracehook: clear TIF_NOTIFY_RESUME in
 tracehook_notify_resume()
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-2-axboe@kernel.dk> <20201008123748.GD9995@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <641b5760-3b0d-0ac9-02e0-5322daba7dad@kernel.dk>
Date:   Thu, 8 Oct 2020 07:36:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201008123748.GD9995@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/20 6:37 AM, Oleg Nesterov wrote:
> Jens, sorry for delay..

No worries, thanks for looking at it!

> On 10/05, Jens Axboe wrote:
>>
>> All the callers currently do this, clean it up and move the clearing
>> into tracehook_notify_resume() instead.
> 
> To me this looks like a good cleanup regardless.

Thanks.

-- 
Jens Axboe

