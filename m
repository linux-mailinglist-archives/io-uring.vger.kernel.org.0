Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E89829094B
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407132AbgJPQG2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405432AbgJPQG1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:06:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D17C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:06:26 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id n9so1708330pgt.8
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NuRq6Ozb7VpJd7RAoCR5EP362roeiSgqhawOdKQ6JUE=;
        b=OtP7/TXXa7Fmvhze//ZGRpup+mfu+rIRMz6PWqlJ9/tczjk0WmKsrt0oeusbiCNKug
         CD3ZHCwT2bZD/BssRzts0NF/jXu85Yeyq03Rw9RQjX1/47FPsQOwvUhSLxsYLGLMf57D
         Bwp18cEM1lo044wqfRrJz2lSKRBBobx/XC7nvkdLQ1cq0xNB8hsL6vshqLf5Iis4WnxR
         Ffkp6lcsMl2I/vPQUzQhHIyBmklnaMGH0S+NOaTko82uFEaJu4DsHz9w7VSEl2qFxEFd
         HNMYHyg+O09AMejiW/VdRX0xV8bL34v7nlnbvlBzX2NjZQIKPOV6HiWi/VlgD8ldkEyH
         pVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NuRq6Ozb7VpJd7RAoCR5EP362roeiSgqhawOdKQ6JUE=;
        b=kn1hqRF0p7VOtU4JG2kX6TXVoExSRA8gmoWhMnmq4Wa+puIzrfiV/iHV+ks/opW/33
         Z7nI8GQOhiq2W8Yar2ZtgvuNWXXm62KfUDOH1JADCBv5AGa2lwq6nJ6QLyJxf07jz5X4
         aes1A6VbE8l6S7dGIM6LAe2oIzW35EfLN7fih4J80LNlDmU10Ls9EGvkZs9WcMvJIEmv
         i6/CWc3iBU+WTYdJFpihmu0DqVlv20sP0XCnpoXHpJJlIcVdmwRGLzEbiRyTzQP+ar87
         uC60Apj6tsKoh5naua9IxS5i9Le3aOIsFYP0xN/EO+tgAaNTowcedpmRt2k+RyVUf2Nd
         +iHQ==
X-Gm-Message-State: AOAM530s+8Ty6v463WdQnuOFfVNRFf04cRtAAtjNDz9KjBONI/VrVC22
        BxB/KhwtLl+Tbv+zXUj7iBvICcPDjv+WpLpr
X-Google-Smtp-Source: ABdhPJzVfJJzF+FaqbrjVpgXENhDDoECvIfbEp2ZDWyjvfrq3+F+6eJbAc0Jo4gXmreGuQMPgLWZ7g==
X-Received: by 2002:a65:6712:: with SMTP id u18mr3639698pgf.84.1602864385781;
        Fri, 16 Oct 2020 09:06:25 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d128sm3309995pfd.94.2020.10.16.09.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 09:06:25 -0700 (PDT)
Subject: Re: Samba with multichannel and io_uring
To:     Stefan Metzmacher <metze@samba.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <53d63041-5931-c5f2-2f31-50b5cbe09ec8@samba.org>
 <efb8b619-ca06-5c6b-e052-0c40b64b9904@kernel.dk>
 <6e7ea4e7-8ef7-9ad4-1377-08749f9bae0b@samba.org>
 <18e153db-5ee9-f286-58ae-30065feda737@kernel.dk>
 <892e855a-9c4f-ea5b-6728-f02df271c2c8@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <461e4fc4-0e7d-2a6f-f2eb-a962b077ed81@kernel.dk>
Date:   Fri, 16 Oct 2020 10:06:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <892e855a-9c4f-ea5b-6728-f02df271c2c8@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 10:03 AM, Stefan Metzmacher wrote:
>>
>> I don't think that's too important, as it's just a snapshot in time. So
>> it'll fluctuate based on the role of the worker.
>>
>>> I just found that proc_task_name() handles PF_WQ_WORKER special
>>> and cat /proc/$pid/comm can expose something like:
>>>   kworker/u17:2-btrfs-worker-high
>>
>> Yep, that's how they do fancier names. It's been on my agenda for a while
>> to do something about this, I'll try and cook something up for 5.11.
> 
> With a function like wq_worker_comm being called by proc_task_name(),
> you would capture current IO_WORKER_F_BOUND state and alter the name.

Oh yes, it'll be accurate enough, my point is just that by the time you
see it, reality might be different. But that's fine, that's how they
work.

> Please CC me on your patches in that direction.

Will do!

-- 
Jens Axboe

