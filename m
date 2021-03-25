Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC45349B27
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 21:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhCYUnv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 16:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhCYUnV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 16:43:21 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A09C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 13:43:21 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id t14so3277000ilu.3
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 13:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TSU2B9M8vT24A3F3SJwsUrhSuRDhhujYOX5JFBLr5Q4=;
        b=cum/hZjQOua9qB39aJPqFwe/yq6t1irZ+vOZH+c75W/UaRUYiV/tu7M7foPTezWsJ7
         HsviJkXLRtZHBPeo4nrdkQBBUtDxt55s0Xy+0OITg//vgiAQw6/vyPGfK4eRHJEmkDCZ
         823G1X77A5BLgs8cVAjNtAle83ZBnoJows4t9y3n/jYmjlTj0i4M1CWi1TywtNJUT9bV
         3Hw3/dd4FOrPhI7cMy3aELH/Ooa7wLm3LbBYexHHMuQwsOJ++B/Q0VRigu/Zzh7GgGYf
         RwjIZKn/wJw7LHGMX7TAXRL5kne2oOoed1VDLag51C0PvbQXe9hoGE8BnlB7f2GNqOOu
         krrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TSU2B9M8vT24A3F3SJwsUrhSuRDhhujYOX5JFBLr5Q4=;
        b=oZBlLVduajbd6menwz2Os5y0e/mqRwK3oDezUk7k9IHR55EC5kAAPho5Btp8D/0bhL
         qTXXUZzeRklMiBUW+6srhE3kc4bOSNSRudrVHrIC6Z8dXAiWbKLDgN3ASNlSCjGlhM+4
         NmnQScwJrilQiioy0msNzG3LNDuia0mHBIx7JF/thUo3R7fAsro7vOBnCSWoTpTseBG5
         I5eoUENAWKgNR8n7svIeDGsTapgJyt0s0i+0LaVgZvd+veAzV+Uvw67R15zX86ovk7Uj
         QT2kPurG9Jy+GyLpRT+kaGsMThd2vyqKWu/HXBDhNzju4AtImU2LDeZL2GaChqnmeu+4
         qk9w==
X-Gm-Message-State: AOAM532svc0YyJTcvNT7xTJEuhQlLyfh1CH9+2q++4F710ZdDOpAGVMr
        JZZwi2TxHw+aBiRoqoFpk2RrbQ==
X-Google-Smtp-Source: ABdhPJy/uscIu0RMY2L8VvuCw+SSmMM4pcYhmikvk3jc8cxC6+l7v3f50aaGHwcTH0r4fduhMtW0Qw==
X-Received: by 2002:a92:bd06:: with SMTP id c6mr8562506ile.158.1616705000985;
        Thu, 25 Mar 2021 13:43:20 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o10sm3181138ilf.46.2021.03.25.13.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 13:43:20 -0700 (PDT)
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
References: <20210325164343.807498-1-axboe@kernel.dk>
 <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <3a1c02a5-db6d-e3e1-6ff5-69dd7cd61258@kernel.dk>
 <m1zgyr2ddh.fsf@fess.ebiederm.org> <20210325204014.GD28349@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <70232822-ced2-30e8-f880-8ebadacc9cc2@kernel.dk>
Date:   Thu, 25 Mar 2021 14:43:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325204014.GD28349@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 2:40 PM, Oleg Nesterov wrote:
> On 03/25, Eric W. Biederman wrote:
>>
>> So looking quickly the flip side of the coin is gdb (and other
>> debuggers) needs a way to know these threads are special, so it can know
>> not to attach.
> 
> may be,
> 
>> I suspect getting -EPERM (or possibly a different error code) when
>> attempting attach is the right was to know that a thread is not
>> available to be debugged.
> 
> may be.
> 
> But I don't think we can blame gdb. The kernel changed the rules, and this
> broke gdb. IOW, I don't agree this is gdb bug.

Right, that's what I was getting at too - and it's likely not just gdb.
We have to ensure that we don't break this use case, which seems to
imply that we:

1) Just make it work, or
2) Make them hidden in such a way that gdb doesn't see them, but
   regular tooling does

#2 seems fraught with peril, and maybe not even possible.

-- 
Jens Axboe

