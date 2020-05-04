Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4744E1C3C47
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 16:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEDOEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 10:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgEDOEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 10:04:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE58C061A0E;
        Mon,  4 May 2020 07:04:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so15972838wra.7;
        Mon, 04 May 2020 07:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DablqqPCpx4w4xSuQkb4zjD/vUdE5t/EFHIl9EZBzFc=;
        b=sC64yDvjCic9ysOEGw9B4LlyryXXRKYB+BpOayHBUBTqbqP/AGryd40AbUyVdJUvnD
         EnGU5+tn1vVn63AoGtEjLQ230B0/xX4KPAba8khJ/EDFjOuTOvxwvZ6yoU2YJfJl9zpO
         MlwGnY8/PkWk9Klh12dCPTAnsJCrBnH35tyOV8iH3NJtTSCJHb2qL9jUcCyqXiOlpwlH
         q8734XIVvdaadG5LV1lGi6FtcTc5C7YCh6SJmq/15XDmLNFT6Ozsb+pt2RAVz4+OiB1v
         UKwN21dmJTXJLaNg8Bof65Qicsl6f4RnJ48bd95zKR2CP7pQ1YgWYiWw8iSrM68tZSjb
         levg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DablqqPCpx4w4xSuQkb4zjD/vUdE5t/EFHIl9EZBzFc=;
        b=HzWyK/cnPdFsxMa7GW7x/I/ACEwOC+uA69t0WmW8XgR6TFGnXS66MNdFZLTlYKGq14
         jNUJHh76oKXRd6J2HSMTHxWYc+VBmerANKVO5+3PjhfNTyg8M+uAP1a4WmH6HJbUkHy4
         g3w8UQNua8eBJ6tJHgn5fRtLeviJkxpcofJQXMw30YUoQkhDRzMtdh/6tEuBySCVnrFU
         9QKqVUQBBaymzIiP0QnrtyMBtT8KBjtRUK8F+LX910FCdQuWc8bQ47mmbVybEh7DWMiH
         pD8QPDz1wFO41NUi3sOfZPbj8R/7sstlO/VK7jpfbGyUuzjr7mDmvPpqDm5I8q938eHM
         RXKg==
X-Gm-Message-State: AGi0Puag8ma8/zhDGB5iXElgR5VWcJOxj49e+H666qzfZqYaGuB/OZLs
        2jpmfDT+dtSabFNJDH7DYaj1Dnld
X-Google-Smtp-Source: APiQypKPtt65x//QawXlJJk5JP3u1ONmQykLAarkmktAy0Jck82jAPze6rA/KYza73c7X0tsZ6euNQ==
X-Received: by 2002:adf:ec09:: with SMTP id x9mr605509wrn.21.1588601084779;
        Mon, 04 May 2020 07:04:44 -0700 (PDT)
Received: from [192.168.43.158] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id y3sm2421305wrt.87.2020.05.04.07.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 07:04:44 -0700 (PDT)
Subject: Re: [PATCH 1/2] splice: export do_tee()
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Clay Harris <bugs@claycon.org>
References: <cover.1588421219.git.asml.silence@gmail.com>
 <56e9c3c84e5dbf0be8272b520a7f26b039724175.1588421219.git.asml.silence@gmail.com>
 <CAG48ez0h6950sPrwfirF2rJ7S0GZhHcBM=+Pm+T2ky=-iFyOKg@mail.gmail.com>
 <387c1e30-cdb0-532b-032e-6b334b9a69fa@gmail.com>
 <b62d84b0-c5a8-402f-d62e-e0b8d41221bb@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <1007c4ff-2af0-1473-a268-a0ae245d8188@gmail.com>
Date:   Mon, 4 May 2020 17:03:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b62d84b0-c5a8-402f-d62e-e0b8d41221bb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 16:43, Jens Axboe wrote:
> On 5/4/20 6:31 AM, Pavel Begunkov wrote:
>> On 04/05/2020 14:09, Jann Horn wrote:
>>> On Sat, May 2, 2020 at 2:10 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> export do_tee() for use in io_uring
>>> [...]
>>>> diff --git a/fs/splice.c b/fs/splice.c
>>> [...]
>>>>   * The 'flags' used are the SPLICE_F_* variants, currently the only
>>>>   * applicable one is SPLICE_F_NONBLOCK.
>>>>   */
>>>> -static long do_tee(struct file *in, struct file *out, size_t len,
>>>> -                  unsigned int flags)
>>>> +long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
>>>>  {
>>>>         struct pipe_inode_info *ipipe = get_pipe_info(in);
>>>>         struct pipe_inode_info *opipe = get_pipe_info(out);
>>>
>>> AFAICS do_tee() in its current form is not something you should be
>>> making available to anything else, because the file mode checks are
>>> performed in sys_tee() instead of in do_tee(). (And I don't see any
>>> check for file modes in your uring patch, but maybe I missed it?) If
>>> you want to make do_tee() available elsewhere, please refactor the
>>> file mode checks over into do_tee().
>>
>> Overlooked it indeed. Glad you found it
> 
> Yeah indeed, that's a glaring oversight on my part too. Will you send
> a patch for 5.7-rc as well for splice?

Absolutely

-- 
Pavel Begunkov
