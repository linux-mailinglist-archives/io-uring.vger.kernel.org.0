Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D747033404D
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 15:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhCJO1T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 09:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhCJO07 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 09:26:59 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE7C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:26:59 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e7so15685056ile.7
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yIRaibrsRIkKXb+iD3yFHrNLgUG6Foz7IExjF6ajw+c=;
        b=gJAcKkRo1uOYCRPT3AqWAPXNxCzcvYnpwhDXUoyqVp+e8HDEMKdmLcLjAPuzkbikVB
         wyw72LT+8vibaSy+uZVD0Ot4wF7fBvScTZTQRwRYONijBvc304lltWmge1x6iNCqYooD
         pmUMHBDasjhvNPfssCCkfbN0/8JtxHm2qHWh1Q4Mt7Bb8RpMW3r486Fg9nKA3EBpGpNX
         gBlMz+fZDUBe5SGI5Ik90b/BCLKdTnPHm0VEecSe/Mv8V/LjWdxk/uioAqH8dlStCTkI
         t1aWrhNJyczMRurahH+CecUFww82rcKj4fgCkZBbXGPnjTxO+8mOO2xEszi/Ocbd2wkN
         d6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yIRaibrsRIkKXb+iD3yFHrNLgUG6Foz7IExjF6ajw+c=;
        b=ZJIte9G897CKTJrwDAhPAsly+U8ForLImrVNeIaQ84IX+ZjRK/d31QidmPgN0EY1Lu
         fRIp8aTZMP2OK2b6qZN5y1eiketrWK4exBe8jdHdibaSrMO4aErGMeNyax7T/VXkbfDW
         zx0MtuMTvpqCPmhoNS/17qOkQHD9LetHtP1VrMn89Id2qDgGWOMWYuL/DWrFnyyci4XE
         tAdJUfRhBtCiwnsgc614neoaqiXSTyxiAX9+46Azkgedj+PdxQd5ypPAPD1f1i1Q4+N3
         dmoM+Imp9o7KQgyBUELJpzrG/8tsMVJ9D+hTevqatN4TCrc7jgXBdT+W+PyXrrzOWJ9Z
         iyEQ==
X-Gm-Message-State: AOAM531DTUMUxgTgdQPkE79SyTTAS8ai9kKAMDN3Z5xAVtZONMZHk3TH
        jHh+5O/OaX1iD+DUli9mq6ueVQ==
X-Google-Smtp-Source: ABdhPJxsAfpscc4DuNlHnSHVAabmgIREeu7mBR9NQ00Heu3w8L52Sq/PS1XSxMrpoynBAgMWfp0d+A==
X-Received: by 2002:a05:6e02:180d:: with SMTP id a13mr2752680ilv.156.1615386418850;
        Wed, 10 Mar 2021 06:26:58 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k14sm9073465iob.34.2021.03.10.06.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:26:58 -0800 (PST)
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <5112d102-d849-c640-868f-ee820163d02e@kernel.dk>
 <20210310041025.2438-1-hdanton@sina.com>
 <b8e8a0f8-12fa-5dc4-6bcc-a274a8b2adec@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d20d356f-6086-f3cd-eca6-f8bd16365686@kernel.dk>
Date:   Wed, 10 Mar 2021 07:26:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b8e8a0f8-12fa-5dc4-6bcc-a274a8b2adec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/21 6:40 AM, Pavel Begunkov wrote:
> On 10/03/2021 04:10, Hillf Danton wrote:> 
>> Fix 05ff6c4a0e07 ("io_uring: SQPOLL parking fixes") in the current tree
>> by removing the extra set of IO_SQ_THREAD_SHOULD_STOP in response to
>> the arrival of urgent signal because it misleads io_sq_thread_stop(),
>> though a followup cleanup should go there.
> 
> That's actually reasonable, just like
> 8bff1bf8abeda ("io_uring: fix io_sq_offload_create error handling")
> 
> Are you going to send a patch?

Agree - Hillf, do you mind if I just fold this one in?

-- 
Jens Axboe

