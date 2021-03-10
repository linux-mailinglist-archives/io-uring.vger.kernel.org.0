Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED83333CE
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 04:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhCJDXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 22:23:55 -0500
Received: from vulcan.kevinlocke.name ([107.191.43.88]:55644 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhCJDX3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 22:23:29 -0500
X-Greylist: delayed 5260 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2021 22:23:29 EST
Received: from kevinolos.kevinlocke.name (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 7619B210AA3F;
        Wed, 10 Mar 2021 03:23:28 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id E3E9313006A0; Tue,  9 Mar 2021 20:23:26 -0700 (MST)
Date:   Tue, 9 Mar 2021 20:23:26 -0700
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Subject: Re: [v5.12-rc2 regression] io_uring: high CPU use after
 suspend-to-ram
Message-ID: <YEg7rmuMjV3FyGBR@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
References: <YEgnIp43/6kFn8GL@kevinlocke.name>
 <0d333d67-9a3e-546d-ad1c-ecebfdbe9932@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d333d67-9a3e-546d-ad1c-ecebfdbe9932@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2021-03-09 at 19:48 -0700, Jens Axboe wrote:
> On 3/9/21 6:55 PM, Kevin Locke wrote:
>> With kernel 5.12-rc2 (and torvalds/master 144c79ef3353), if mpd is
>> playing or paused when my system is suspended-to-ram, when the system is
>> resumed mpd will consume ~200% CPU until killed.  It continues to
>> produce audio and respond to pause/play commands, which do not affect
>> CPU usage.  This occurs with either pulse (to PulseAudio or
>> PipeWire-as-PulseAudio) or alsa audio_output.
> 
> The below makes it work as expected for me - but I don't quite
> understand why we're continually running after the freeze. Adding Rafael
> to help understand this.

I can confirm that your patch resolves the high CPU usage after suspend
on my system as well.  Many thanks!

Tested-by: Kevin Locke <kevin@kevinlocke.name>

Happy to test any future revisions as well.

Thanks again,
Kevin
