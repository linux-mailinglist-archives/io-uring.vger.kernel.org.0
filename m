Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95EB68A3B4
	for <lists+io-uring@lfdr.de>; Fri,  3 Feb 2023 21:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbjBCUoA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Feb 2023 15:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjBCUn7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Feb 2023 15:43:59 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE021DB8D
        for <io-uring@vger.kernel.org>; Fri,  3 Feb 2023 12:43:58 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 8678782FFE;
        Fri,  3 Feb 2023 20:43:56 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675457038;
        bh=3b/gw95cXR0A0r9CJjY0DPFdXrRfo0ly5IS+A3pXaZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IWu53Rkxp3bukvSflKiY6GKinQGrAvGY/e/d1xD2rwfTa5t/zUdgX/1HSl1Kw7EoP
         aNd6cOoO4Uo8b3NyHw7ITdaqpiK7k94hIQucmMRYeht3INT6/aG7FpzxWRgytV7KmQ
         uEFTh83VkYiiz+J8QW6YWZju04uSnf28EOJJ8vk3PWAqArHyi9uphbEy8McWgo+04w
         4hIXl04DSoLdf4Xcq4jq2DXtRsbv0ZCSV3+NqehTQFXZ/VW1T+SmKIgAAS3C8kdwVJ
         ZBAEn8E6/KJnZjypHwvWO220TSRAcUFYdd5+cWdLuvq68Kfn398yGiaF5oSxl11Zs3
         b/TLW9zNMv//w==
Date:   Sat, 4 Feb 2023 03:43:52 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 3/4] liburing: add example programs for napi busy poll
Message-ID: <Y91yCGR0mQkZC+TS@biznet-home.integral.gnuweeb.org>
References: <20230203190310.2900766-1-shr@devkernel.io>
 <20230203190310.2900766-4-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203190310.2900766-4-shr@devkernel.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 03, 2023 at 11:03:09AM -0800, Stefan Roesch wrote:
> This adds two example programs to test the napi busy poll functionality.
> It consists of a client program and a server program. To get a napi id,
> the client and the server program need to be run on different hosts.
> 
> To test the napi busy poll timeout, the -t needs to be specified. A
> reasonable value for the busy poll timeout is 100. By specifying the
> busy poll timeout on the server and the client the best results are
> accomplished.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>

Those two break liburing's upstream CI. Also, it has many whitespace
issues:

Applying: liburing: add example programs for napi busy poll
.git/rebase-apply/patch:258: space before tab in indent.
        	avgRTT += ctx->rtt[i];
.git/rebase-apply/patch:382: space before tab in indent.
        	fprintf(stderr, "inet_pton error for %s\n", optarg);
.git/rebase-apply/patch:391: space before tab in indent.
        	fprintf(stderr, "socket() failed: (%d) %s\n", errno, strerror(errno));
.git/rebase-apply/patch:392: space before tab in indent.
        	exit(1);
.git/rebase-apply/patch:794: space before tab in indent.
        	fprintf(stderr, "inet_pton error for %s\n", optarg);
warning: squelched 2 whitespace errors
warning: 7 lines add whitespace errors.

-----------------------------------------------------------

napi-busy-poll-client.c:65:15: error: no previous extern declaration for non-static variable 'longopts' [-Werror,-Wmissing-variable-declarations]
struct option longopts[] =
              ^
napi-busy-poll-client.c:65:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
struct option longopts[] =
^
napi-busy-poll-client.c:435:28: error: comparison of integers of different signs: 'int' and '__u32' (aka 'unsigned int') [-Werror,-Wsign-compare]
                if (opt.timeout          != napi.busy_poll_to ||
                    ~~~~~~~~~~~          ^  ~~~~~~~~~~~~~~~~~
napi-busy-poll-client.c:50:3: error: no previous extern declaration for non-static variable 'ctx' [-Werror,-Wmissing-variable-declarations]
} ctx;
  ^
napi-busy-poll-client.c:33:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
struct ctx
^
napi-busy-poll-client.c:63:3: error: no previous extern declaration for non-static variable 'options' [-Werror,-Wmissing-variable-declarations]
} options;
  ^
napi-busy-poll-client.c:52:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
struct options
^
4 errors generated.
make[1]: *** [Makefile:38: napi-busy-poll-client] Error 1
make[1]: *** Waiting for unfinished jobs....
napi-busy-poll-server.c:64:15: error: no previous extern declaration for non-static variable 'longopts' [-Werror,-Wmissing-variable-declarations]
struct option longopts[] =
              ^
napi-busy-poll-server.c:64:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
struct option longopts[] =
^
napi-busy-poll-server.c:110:32: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
static void setProcessScheduler()
                               ^
                                void
napi-busy-poll-server.c:48:3: error: no previous extern declaration for non-static variable 'ctx' [-Werror,-Wmissing-variable-declarations]
} ctx;
  ^
napi-busy-poll-server.c:32:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
struct ctx
^
napi-busy-poll-server.c:62:3: error: no previous extern declaration for non-static variable 'options' [-Werror,-Wmissing-variable-declarations]
} options;
  ^
napi-busy-poll-server.c:50:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
struct options
^
4 errors generated.
make[1]: *** [Makefile:38: napi-busy-poll-server] Error 1
make[1]: Leaving directory '/home/runner/work/liburing/liburing/examples'
make: *** [Makefile:12: all] Error 2
Error: Process completed with exit code 2.

-- 
Ammar Faizi

