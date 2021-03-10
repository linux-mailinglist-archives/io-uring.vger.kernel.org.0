Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FE63332EB
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 03:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhCJCBD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 21:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhCJCA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 21:00:56 -0500
X-Greylist: delayed 306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 09 Mar 2021 18:00:56 PST
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2061EC06174A;
        Tue,  9 Mar 2021 18:00:56 -0800 (PST)
Received: from kevinolos.kevinlocke.name (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id EC6F0210A6DC;
        Wed, 10 Mar 2021 01:55:48 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id 89D311300698; Tue,  9 Mar 2021 18:55:46 -0700 (MST)
Date:   Tue, 9 Mar 2021 18:55:46 -0700
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v5.12-rc2 regression] io_uring: high CPU use after suspend-to-ram
Message-ID: <YEgnIp43/6kFn8GL@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With kernel 5.12-rc2 (and torvalds/master 144c79ef3353), if mpd is
playing or paused when my system is suspended-to-ram, when the system is
resumed mpd will consume ~200% CPU until killed.  It continues to
produce audio and respond to pause/play commands, which do not affect
CPU usage.  This occurs with either pulse (to PulseAudio or
PipeWire-as-PulseAudio) or alsa audio_output.

The issue appears to have been introduced by a combination of two
commits: 3bfe6106693b caused freeze on suspend-to-ram when mpd is paused
or playing.  e4b4a13f4941 fixed suspend-to-ram, but introduced the high
CPU on resume.

I attempted to further diagnose using `perf record -p $(pidof mpd)`.
Running for about a minute after resume shows ~280 MMAP2 events and
almost nothing else.  I'm not sure what to make of that or how to
further investigate.

Let me know if there's anything else I can do to help diagnose/test.

Thanks,
Kevin
