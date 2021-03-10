Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866B133409B
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 15:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCJOpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 09:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCJOpD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 09:45:03 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49E5C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:45:03 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id o11so18205798iob.1
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 06:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lpHU9Z06I3ZLqqdmnhOHsbTsUx3TMVYCwOYcEQja0+E=;
        b=w/GtcqKVdprrDYj1MjWLN/IeceW/hpxjovERePj87KK+i1+pMEFXv+lt/Nnt+Slv8S
         b79VFWTiQDYLCjJIQUqjJ5muLNUVmg+yRRs2gdMtCVMRtrB4nLc1L+2+zoutwr5NB6EK
         eWCTrHeisTWeludslZMWOhA2x8HkccKbNJkVSCPJ0Lxy8zyX2jVbqlJ+8PGzTyFZ4l5v
         EB/2hKjvciTnbI/8NSZy3KmjMOScJ9OvUTNzuP9SJ+50BNiNACXYFrz40i0F7z8RRkl1
         RT1FrkuE6qH3lCvwDA2Ab8aiPuene05J3pRocfwj6owSxBQTO/InAOk86ngUfCokmjZ6
         cvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lpHU9Z06I3ZLqqdmnhOHsbTsUx3TMVYCwOYcEQja0+E=;
        b=G+5gRSOeDT+meSq507Llz0TGhJio0nWC7eMXLDIV7U0I7RrJ3EoOKees6qIo3OJbPB
         p7+tyxCWuh+1kSVADKbNUXMKbjcwD+snyCdlg8H1fScjAyTZCeeQP2uguJYV5VjkbFwY
         LAWXDjRHeW4YNLzLzSFL2U8w5BPgdxpfpfA/CDiS321YIA3uLcsstUsmy53TvZX54vO6
         /Z8Y/hXW8bk4gcZ6cSyQFqj0z/g+tft67gAE2foBQhWP7tGDh1EKA3bjlC7D6pQ4X8V4
         e9DoQ13FTlzolHNfWkUeA8vdjgYrrvpF/74/gO8VZVDzGV/RUVtIAdv4WJc6ySlYqmb3
         /eYA==
X-Gm-Message-State: AOAM530h85PuFrhoEnSvKc/+YAgx6T5mWGgMsEpcmdDy+fhWEydQa4cZ
        JBYLYsjtar/dwxRU3eNSzSTDMR9yWYRK1A==
X-Google-Smtp-Source: ABdhPJzHmYDxRh16Sc+zeDXIZ8Dupx02kP7PsLcgbZ7VfPfgrTSVPilRkgyUm1R26M/l3SEXPe7Ufw==
X-Received: by 2002:a6b:b5c2:: with SMTP id e185mr2577150iof.204.1615387503245;
        Wed, 10 Mar 2021 06:45:03 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w3sm9188359ill.80.2021.03.10.06.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 06:45:02 -0800 (PST)
Subject: Re: [v5.12-rc2 regression] io_uring: high CPU use after
 suspend-to-ram
To:     Kevin Locke <kevin@kevinlocke.name>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
References: <YEgnIp43/6kFn8GL@kevinlocke.name>
 <0d333d67-9a3e-546d-ad1c-ecebfdbe9932@kernel.dk>
 <YEg7rmuMjV3FyGBR@kevinlocke.name>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <344c1326-0d32-c855-4c30-cfefd9746a2a@kernel.dk>
Date:   Wed, 10 Mar 2021 07:45:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YEg7rmuMjV3FyGBR@kevinlocke.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/21 8:23 PM, Kevin Locke wrote:
> On Tue, 2021-03-09 at 19:48 -0700, Jens Axboe wrote:
>> On 3/9/21 6:55 PM, Kevin Locke wrote:
>>> With kernel 5.12-rc2 (and torvalds/master 144c79ef3353), if mpd is
>>> playing or paused when my system is suspended-to-ram, when the system is
>>> resumed mpd will consume ~200% CPU until killed.  It continues to
>>> produce audio and respond to pause/play commands, which do not affect
>>> CPU usage.  This occurs with either pulse (to PulseAudio or
>>> PipeWire-as-PulseAudio) or alsa audio_output.
>>
>> The below makes it work as expected for me - but I don't quite
>> understand why we're continually running after the freeze. Adding Rafael
>> to help understand this.
> 
> I can confirm that your patch resolves the high CPU usage after suspend
> on my system as well.  Many thanks!
> 
> Tested-by: Kevin Locke <kevin@kevinlocke.name>
> 
> Happy to test any future revisions as well.

Thanks, I'll just hold on to this version for now. It's how it would've
worked before the thread rework anyway. I'd still like to understand why
the thaw leaves them spinning, though :-). But once that is understood,
we can potentially just enable freezing again as a separate patch.
Fixing this one is more important for the time being.

-- 
Jens Axboe

