Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5601C400E
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgEDQhd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 12:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729525AbgEDQhc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 12:37:32 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E64C061A0E;
        Mon,  4 May 2020 09:37:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so236256wmg.1;
        Mon, 04 May 2020 09:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XpnOB9rc7n9qfSHlnZribjJN6qDF52tRyJ8Jd4talvc=;
        b=CNDvjkSqOBUrqhmgcOZVvJkaiqU494jlCmPFep3pYtu1QwFDuht7oTa5xcVuP3UQy6
         LimDWUYF1hmO+UNTfHZsMTSuD4NoWBgY4mt8GxtH77sXPeZXTZckiB082kaEfftsnYFG
         IRgcegf3YJ7o0y/JmHSMIf0LN4pg6YvQ60OztqZH3xhjeBrG5zK9YH3vqMSqqaDVHvla
         7rq9ozH6ZO6g0a0DXsC6GD/qy+WfjYai6eYmynUMqHqpuJ8mnu+VwvcFl0AgCMJplM5w
         9DLhGrJQtu+QhcY5WaAy+rHTUEMGHTuRME4B8U4eJTobXLKQrcBZipPORyUAskZRbzQj
         Q4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XpnOB9rc7n9qfSHlnZribjJN6qDF52tRyJ8Jd4talvc=;
        b=TrUtjicW4RogxTbyI++6hGXiv9TCRhcbVw6UXyP9nkhtL+1FhY6Cz2jbDvgzNKGyZ4
         pBk+D5EkJrn9jNhQ2jmCePt72u3nN41TWc6C+LkzaPiu8ev2xzLPzjXW+//SfdRtEE8N
         nv33EqULtmNj7WD61zuJbUXGRSLSgBpElGMw3RlWpM+sUNugxuNF/vG8HaNMV8HmISQk
         v74kI/wBN6zBuLjeEUrSXlJjUuiN3lKEzVfI9Sjv7m0CF1US90NbYzCk7g51D8uNdbBA
         nNhw7T3JOv0TtX3bljNvDG5UqAvhH3QD8WUy9pNlTzrB2SFG/BTHuU3txStIhGDsmPi1
         Bvqw==
X-Gm-Message-State: AGi0Puap/z8Dy1XzCtAFWZYuB46wFlan5lX6j81u1XMgVjRqvOweJmPq
        kKJ5HEM8SQ8ksa2GyIQB6fczlPw/lbE=
X-Google-Smtp-Source: APiQypJ4/yGGQzpEBAQzSIluwdJKnWVlYhxEM/j/uy7JHHHARVFC5goyXXXoCz02KFsBR5TivGlqog==
X-Received: by 2002:a7b:c44d:: with SMTP id l13mr15024815wmi.72.1588610251118;
        Mon, 04 May 2020 09:37:31 -0700 (PDT)
Received: from [192.168.43.158] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id j11sm19410332wrr.62.2020.05.04.09.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:37:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
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
 <1007c4ff-2af0-1473-a268-a0ae245d8188@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/2] splice: export do_tee()
Message-ID: <9d43b5b5-577b-bc44-1667-fdd2055e63d7@gmail.com>
Date:   Mon, 4 May 2020 19:36:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1007c4ff-2af0-1473-a268-a0ae245d8188@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 17:03, Pavel Begunkov wrote:
> On 04/05/2020 16:43, Jens Axboe wrote:
>> On 5/4/20 6:31 AM, Pavel Begunkov wrote:
>>> On 04/05/2020 14:09, Jann Horn wrote:
>>>> On Sat, May 2, 2020 at 2:10 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>> export do_tee() for use in io_uring
>>>> [...]
>>>>> diff --git a/fs/splice.c b/fs/splice.c
>>>> [...]
>>>>>   * The 'flags' used are the SPLICE_F_* variants, currently the only
>>>>>   * applicable one is SPLICE_F_NONBLOCK.
>>>>>   */
>>>>> -static long do_tee(struct file *in, struct file *out, size_t len,
>>>>> -                  unsigned int flags)
>>>>> +long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
>>>>>  {
>>>>>         struct pipe_inode_info *ipipe = get_pipe_info(in);
>>>>>         struct pipe_inode_info *opipe = get_pipe_info(out);
>>>>
>>>> AFAICS do_tee() in its current form is not something you should be
>>>> making available to anything else, because the file mode checks are
>>>> performed in sys_tee() instead of in do_tee(). (And I don't see any
>>>> check for file modes in your uring patch, but maybe I missed it?) If
>>>> you want to make do_tee() available elsewhere, please refactor the
>>>> file mode checks over into do_tee().
>>>
>>> Overlooked it indeed. Glad you found it
>>
>> Yeah indeed, that's a glaring oversight on my part too. Will you send
>> a patch for 5.7-rc as well for splice?
> 
> Absolutely

The right way would be to do as Jann proposed, but would you prefer an
io_uring.c local fix for-5.7 and then a proper one? I assume it could be easier
to manage.

-- 
Pavel Begunkov
