Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AC267F215
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 00:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjA0XKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 18:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjA0XKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 18:10:42 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C153FF20
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:10:41 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nm12-20020a17090b19cc00b0022c2155cc0bso6108259pjb.4
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EntdOLcS7rI9knFAWkzoXYdckCvZIyQDgx0uXCkNU2k=;
        b=K6qzUedKgblRp8t8bzWpsSDeyFo4z1ieLkO7Uz+wOr1TvPS5Ni0SzHWIsk1ZCUFSK4
         9gQIgBnws/yLr+lKzPWWW5fFPIpUiJFOS1qu/UZ5FIqjhaDMKZhddr2ccG12mCzaF8Yb
         uLkIbWXklkMMmbFaI/w7kBt4fi4GHvlPihER3iCiZpxGmT9XXdqrTj7hGUBdcpw+nBav
         cSIy3Q/93kI0qlez3EIBHFc3fkNo8Qg9YT5NcnIsq7vnibcDuG44vr9vdM1P1fEnP+pp
         38uYU2gQ/EH44diSLWP4rI5mOa9ycuA9euLYRZi8L0ofDW4oT16OYO8+FPo8UuOzFXB0
         dHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EntdOLcS7rI9knFAWkzoXYdckCvZIyQDgx0uXCkNU2k=;
        b=je3XdapxCeuXueBtJMzW6ukQNqCZ8gZFZIuShJYYn2K0LgFDpK3HxvuWto6uV4Ufx1
         8QzXQ5mKLDPKZaiqXHCWvXFeM+4UGIR5niP+rRwcj2EzGLOnnIgSD/DTf/i4Wdc84RFg
         NLoeH2ZdjHC2foplXE7MiWrkbJMHWSV2NHcRm5U9K5eGOP+K//8q4uwef+JQaUxDsXHG
         qli3mDrP/xJka0GpI9HJyWjWselQnRbn8BpKnh3IAC0EgWilLlmEGvKeFfLPD9zAh88g
         I+dWtiunR6i1h0L+x20fEFNHMFLw1Eb+R5uD50mL2vQiFQjeOeMsNM3y+1vREtdxuUye
         2f0w==
X-Gm-Message-State: AO0yUKULZdihzD34LkajL2MGuce6t2z2uZTGe7sSaFBSY5zKedJocFgn
        J7kYhxerE7kh+b/nXG7/cmwwKA==
X-Google-Smtp-Source: AK7set/lFgZctNO6xhXfv8SsT6QA9EH+m5gtjjoBeb2+VQKnSt0Te0W6fhWp+zsBySEKIbREpI9VaA==
X-Received: by 2002:a17:902:e549:b0:196:6308:c9d3 with SMTP id n9-20020a170902e54900b001966308c9d3mr252076plf.0.1674861040463;
        Fri, 27 Jan 2023 15:10:40 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g5-20020a1709026b4500b0019479636f84sm3387314plt.11.2023.01.27.15.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 15:10:39 -0800 (PST)
Message-ID: <1baacdfb-0b40-28be-3e46-049013d92bb4@kernel.dk>
Date:   Fri, 27 Jan 2023 16:10:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
 <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
 <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk>
 <CAHC9VhRuvV9vjhmTM4eGJkWmpZmSkgVaoQ=L6g3cahej-F52tQ@mail.gmail.com>
 <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk>
 <CAHC9VhRpu7WZDqWKcLDj18A0Z5FJdUU=eUL3wbJH1CnEBWB4GA@mail.gmail.com>
 <7904e869-f885-e406-9fe6-495a6e9790e4@kernel.dk>
 <CAHC9VhRipXMCiaGZ-9YLycKWaq1FnV0ybC2B7G8Dua56P7bHkw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhRipXMCiaGZ-9YLycKWaq1FnV0ybC2B7G8Dua56P7bHkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/23 4:08 PM, Paul Moore wrote:
> On Fri, Jan 27, 2023 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/27/23 3:53 PM, Paul Moore wrote:
>>> On Fri, Jan 27, 2023 at 5:46 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 1/27/23 3:38 PM, Paul Moore wrote:
>>>>> On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 1/27/23 12:42 PM, Paul Moore wrote:
>>>>>>> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> On 1/27/23 10:23 AM, Richard Guy Briggs wrote:
>>>>>>>>> A couple of updates to the iouring ops audit bypass selections suggested in
>>>>>>>>> consultation with Steve Grubb.
>>>>>>>>>
>>>>>>>>> Richard Guy Briggs (2):
>>>>>>>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
>>>>>>>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
>>>>>>>>>
>>>>>>>>>  io_uring/opdef.c | 4 +++-
>>>>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> Look fine to me - we should probably add stable to both of them, just
>>>>>>>> to keep things consistent across releases. I can queue them up for 6.3.
>>>>>>>
>>>>>>> Please hold off until I've had a chance to look them over ...
>>>>>>
>>>>>> I haven't taken anything yet, for things like this I always let it
>>>>>> simmer until people have had a chance to do so.
>>>>>
>>>>> Thanks.  FWIW, that sounds very reasonable to me, but I've seen lots
>>>>> of different behaviors across subsystems and wanted to make sure we
>>>>> were on the same page.
>>>>
>>>> Sounds fair. BTW, can we stop CC'ing closed lists on patch
>>>> submissions? Getting these:
>>>>
>>>> Your message to Linux-audit awaits moderator approval
>>>>
>>>> on every reply is really annoying.
>>>
>>> We kinda need audit related stuff on the linux-audit list, that's our
>>> mailing list for audit stuff.
>>
>> Sure, but then it should be open. Or do separate postings or something.
>> CC'ing a closed list with open lists and sending email to people that
>> are not on that closed list is bad form.
> 
> Agree, that's why I said in my reply that it was crap that the
> linux-audit list is moderated and asked Richard/Steve to open it up.

And thanks for that, I just skipped it in the reply as it wasn't for
me.

-- 
Jens Axboe


