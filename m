Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EC64EC805
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 17:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348100AbiC3PTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 11:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348070AbiC3PTA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 11:19:00 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FAF15282F
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:17:15 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q11so25097100iod.6
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 08:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iGEdLMcn3SifjAOV+ZzQedVQz7WLqJG/XzoUgHbkOT0=;
        b=Jsm48F+hpFoutThRN/P/TxXDICv3xi6QCi/fDjrzWMaORlhp2pQoVmtLY6VsYU4tCk
         +j2TsaENBsuDhp43sSOXCHmXRVu+VIZvlggLCoqmzXMssN+bKzeue70PRe/4sOipsmJQ
         Mj8GWBkWQKXt8DlrOTrLSPq/xfr1IoNNbWZlbPp1WwQSMgjN4mi7rVMHcp8I1SEvtQ7O
         92ocEFM8dekwRwxuc1sW/SxvtIG+0xhh7tONPP2y2ZgfJoofjXZVMGOPYFIlRqcd6utY
         bUMUOymoucA9NKL0UjINKiCt8zdwMPbdz00KqYSVrYY0jeSFo+fyCp2xT470jWUai5HV
         lKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iGEdLMcn3SifjAOV+ZzQedVQz7WLqJG/XzoUgHbkOT0=;
        b=RRKycA0r5aZJxYsG93Xt2rvnr2X0ouTf97+YdDFOieGjC013Q7fw10/fMSgB7FyxEs
         zvYSjCTSrOGauq8S8M5xSTcAxWolDENzXmZGacwSyTdoQybBfoAaTSGbmn9dmQLgk/g8
         p64mc6LyiQNWrh9E3kzwn4Duw5KV6fsNe5CeNTsugg6yUJ/MVWz8qhmBbYQH6DElRMxJ
         BTjzKDBC1C/cr0AxSYL/s1mXz6mQ02cIAgGW3bghGBnPu0Hl9ZVwwAqm1hWA1nmn0EMi
         hy+vRHvIqRxI34QF0yalH2SB0aSY/JfrfznjFrlI5QK/ThqrTrzTyMh3VVuoyApWtTTV
         yeWQ==
X-Gm-Message-State: AOAM532eGRhEYIx5xCPfTFCxkafUJHjTbPou3kD/B9dA0PWYLUvuVwav
        nf9VQRA7Ipvg6fvjtqUJXgITSJZx/pa1Vl0t
X-Google-Smtp-Source: ABdhPJxk3xnJS0Qkc4kozadKGbDRd1i8YJYYMkc0fwuUXe2trRKXEn8oGHq57gCdVWdWtTgAbAbZJQ==
X-Received: by 2002:a6b:8d8b:0:b0:645:eb9e:6765 with SMTP id p133-20020a6b8d8b000000b00645eb9e6765mr11622140iod.215.1648653434996;
        Wed, 30 Mar 2022 08:17:14 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f4-20020a92b504000000b002c21ef70a81sm10774446ile.7.2022.03.30.08.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 08:17:14 -0700 (PDT)
Message-ID: <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk>
Date:   Wed, 30 Mar 2022 09:17:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
 <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
 <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/30/22 9:12 AM, Miklos Szeredi wrote:
> On Wed, 30 Mar 2022 at 17:05, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/30/22 8:58 AM, Miklos Szeredi wrote:
>>> Next issue:  seems like file slot reuse is not working correctly.
>>> Attached program compares reads using io_uring with plain reads of
>>> proc files.
>>>
>>> In the below example it is using two slots alternately but the number
>>> of slots does not seem to matter, read is apparently always using a
>>> stale file (the prior one to the most recent open on that slot).  See
>>> how the sizes of the files lag by two lines:
>>>
>>> root@kvm:~# ./procreads
>>> procreads: /proc/1/stat: ok (313)
>>> procreads: /proc/2/stat: ok (149)
>>> procreads: /proc/3/stat: read size mismatch 313/150
>>> procreads: /proc/4/stat: read size mismatch 149/154
>>> procreads: /proc/5/stat: read size mismatch 150/161
>>> procreads: /proc/6/stat: read size mismatch 154/171
>>> ...
>>>
>>> Any ideas?
>>
>> Didn't look at your code yet, but with the current tree, this is the
>> behavior when a fixed file is used:
>>
>> At prep time, if the slot is valid it is used. If it isn't valid,
>> assignment is deferred until the request is issued.
>>
>> Which granted is a bit weird. It means that if you do:
>>
>> <open fileA into slot 1, slot 1 currently unused><read slot 1>
>>
>> the read will read from fileA. But for:
>>
>> <open fileB into slot 1, slot 1 is fileA currently><read slot 1>
>>
>> since slot 1 is already valid at prep time for the read, the read will
>> be from fileA again.
>>
>> Is this what you are seeing? It's definitely a bit confusing, and the
>> only reason why I didn't change it is because it could potentially break
>> applications. Don't think there's a high risk of that, however, so may
>> indeed be worth it to just bite the bullet and the assignment is
>> consistent (eg always done from the perspective of the previous
>> dependent request having completed).
>>
>> Is this what you are seeing?
> 
> Right, this explains it.   Then the only workaround would be to wait
> for the open to finish before submitting the read, but that would
> defeat the whole point of using io_uring for this purpose.

Honestly, I think we should just change it during this round, making it
consistent with the "slot is unused" use case. The old use case is more
more of a "it happened to work" vs the newer consistent behavior of "we
always assign the file when execution starts on the request".

Let me spin a patch, would be great if you could test.

-- 
Jens Axboe

