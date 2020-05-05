Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD001C5F3F
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 19:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgEERuH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 13:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbgEERuH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 13:50:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D4FC061A0F
        for <io-uring@vger.kernel.org>; Tue,  5 May 2020 10:50:06 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i19so2861675ioh.12
        for <io-uring@vger.kernel.org>; Tue, 05 May 2020 10:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N43Z8kYSmr6COpNX9lV1XdAuC1wnybUlQx7BgbfcavQ=;
        b=ZO9ThHVP2Bd2VlyEaCJnoodj36sE2Qw3jkeL8t0911T0C/DBLNsF7s2/L6e3ussM92
         3jzNGTcabXtFmwSQlIRFcALMha96VQAUAxuR42Eb75Wl0GGN8blArWG25LRN1FVxr40v
         LVPee0Kh2EmuNt3CY2o+aFreaLZXPY9zV6UXHrhWjRY6Ywv2L/eW8AgFcu8tElBSn2ua
         XWCUcO/2A6k4zpLkgtZocpbsXmNNbU/LMYyvAEQfY3QFppDddAXBLOeQYRkJhtCzc4Nk
         chb7a54n/OOziwcrXxVVH+LmnXNLOyEoC6fR11DDxXl06s69oYl86zmHr9VN3IrNoNuf
         D86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N43Z8kYSmr6COpNX9lV1XdAuC1wnybUlQx7BgbfcavQ=;
        b=tPuInQ0ZPw9FIFW1TapS6ZvVihs5nXiElpV5u7C5vbis/jFNuQLHFUiQ9hqoR/fDa+
         p5p2G7mx5nDB4gyaBi74+e6EWP96o4gUQ0BSM/zvHA6hDSQJERAZc5w7qeZU7ZzwLyWN
         Nseq2Mcl9sBe0OPmHqUrM01Qhyq2pYMDdwYPd3b0pshti5X9StJZzCD8pAx7SCqt4+V2
         xOzXQeHz1Ok9Lvbapb9vcmeiDmqsNFwZXGn4CPtE9FbFng8WMGkFH2Kr4yMYawLFYEGh
         yL5gSTnmSwgGrpvbD7UyA/Ltc7yfEIHA1+fPiFUIBrOLrixonQBOv1Q6Lmh1EOFA6qrM
         wgsg==
X-Gm-Message-State: AGi0PuZaJzsxT8oLUU2ipMA+GV9Whwq/PswaXX4Yy+P4IIRUFNhuWjoS
        9ShFW6eWuWXcc9mQLJLqYCLSws9z27TWww==
X-Google-Smtp-Source: APiQypISEn0jWxZVHaO2D7lS+atPlZTuX6SzPC1rCYrsbS8MhSi6hfBxgR5zrV68Yf71AVzqV1czpA==
X-Received: by 2002:a5d:8045:: with SMTP id b5mr4565237ior.16.1588701005039;
        Tue, 05 May 2020 10:50:05 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f28sm2117435ilg.52.2020.05.05.10.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:50:04 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
To:     Jeremy Allison <jra@samba.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <f782fc6d-0f89-dca7-3bb0-58ef8f662392@kernel.dk>
 <20200505174832.GC7920@jeremy-acer>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b2ee1dc-7131-66f9-e6d8-a4de1d4ae679@kernel.dk>
Date:   Tue, 5 May 2020 11:50:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505174832.GC7920@jeremy-acer>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/20 11:48 AM, Jeremy Allison wrote:
> On Tue, May 05, 2020 at 11:39:14AM -0600, Jens Axboe wrote:
>>>
>>> I'll try and see if I can get an arch binary build that has the
>>> vfs_io_uring module and reproduce.
>>
>> Got that done, and I can now mount it on Linux. Been trying pretty
>> hard to trigger any corruptions on reads, but it works for me. Checked
>> that we see short reads, and we do, and that it handles it just fine.
>> So pretty blank right now on what this could be.
>>
>> FWIW, I'm mounting on Linux as:
>>
>> # mount -t cifs -o ro,guest //arch/data /smb
> 
> The reporter claims this only happens with
> a Windows client, as the Linux and Samba libsmb
> clients don't pipeline the reads in the same
> way for multiple files the same way that Windows
> does.
> 
> Here is the bug report with all the details I've
> managed to get out of the original reporter:
> 
> https://bugzilla.samba.org/show_bug.cgi?id=14361
> 
> I also can't reproduce the data corruption, even
> from a Windows client although I've only tried
> so far on my home Ubuntu 19.04 kernel 5.3.0-51-generic #44-Ubuntu SMP
> box.
> 
> I tried running 2 powershell processes on the
> Windows client and doing a copy in both of them
> to ensure we are opening multiple files simultaneously
> and going through the io_uring module (which I
> saw happening by adding debug statements) but
> I never see corruption.
> 
> I'm planning to try running against a Fedora32
> VM next, as that's case the reporter claims will
> reproduce the issue.
> 
> Thanks for helping me look at this !

Thanks for the detailed reply! If you figure out a way to
reproduce on Linux, please send me a note and I'll be happy
to dive further into this.

-- 
Jens Axboe

