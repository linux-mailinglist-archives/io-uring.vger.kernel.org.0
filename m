Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BB25BBF09
	for <lists+io-uring@lfdr.de>; Sun, 18 Sep 2022 19:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiIRRFO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Sep 2022 13:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIRRFN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Sep 2022 13:05:13 -0400
X-Greylist: delayed 535 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 18 Sep 2022 10:05:12 PDT
Received: from dd11108.kasserver.com (dd11108.kasserver.com [85.13.147.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED10D1AF0C
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 10:05:12 -0700 (PDT)
Received: from dd11108.kasserver.com (dd0806.kasserver.com [85.13.161.252])
        by dd11108.kasserver.com (Postfix) with ESMTPSA id 38AC12FC059D
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 18:56:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hanne.name;
        s=kas202203241025; t=1663520176;
        bh=asTfI8gWg0RyMMjxF4GNY1MxLG9uh0hugHs951xz5jk=;
        h=Subject:To:From:Date:From;
        b=b1UjJkqwwQ/Tehta8UOX6Jo6wegmIt/ZRGBToR/KibxqSAlGObJsAlIXAqcy3bbAp
         Y+wB9p3rpdkyommX257HDuDQ+dVA1IEM3oJPW+R2/qIWgAE7hfk4IHfdH+G8Z8j4IJ
         UgrfxHAtDxrkKscojmhovCq3uTdA6bOPpjFQafoSZu1VFzcKTeaJPc+TwbnsKcpKLf
         BPCDF7FQm384heXo6UUXYH5Vaog+qX84KsXRlR68p+cc36Zo6cxDCrRZb9XIgbIdOX
         0G9MefV9EhxdQbiJ0H+LtXfa3+ai4k1Kp1inOGqjROJ3oPwblTQM0VoBxA8IR35ZBi
         D7xVZfdrzbi0A==
Subject: Memory ordering description in io_uring.pdf
To:     io-uring@vger.kernel.org
From:   "J. Hanne" <io_uring@jf.hanne.name>
User-Agent: ALL-INKL Webmail 2.11
X-SenderIP: 84.135.111.49
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Message-Id: <20220918165616.38AC12FC059D@dd11108.kasserver.com>
Date:   Sun, 18 Sep 2022 18:56:16 +0200 (CEST)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I have a couple of questions regarding the necessity of including memory
barriers when using io_uring, as outlined in
https://kernel.dk/io_uring.pdf. I'm fine with using liburing, but still I
do want to understand what is going on behind the scenes, so any comment
would be appreciated.

Firstly, I wonder why memory barriers are required at all, when NOT using
polled mode. Because requiring them in non-polled mode somehow implies that:
- Memory re-ordering occurs across system-call boundaries (i.e. when
  submitting, the tail write could happen after the io_uring_enter
  syscall?!)
- CPU data dependency checks do not work
So, are memory barriers really required when just using a simple
loop around io_uring_enter with completely synchronous processing?

Secondly, the examples in io_uring.pdf suggest that checking completion
entries requires a read_barrier and a write_barrier and submitting entries
requires *two* write_barriers. Really?

My expectation would be, just as with "normal" inter-thread userspace ipc,
that plain store-release and load-acquire semantics are sufficient, e.g.: 
- For reading completion entries:
-- first read the CQ ring head (without any ordering enforcement)
-- then use __atomic_load(__ATOMIC_ACQUIRE) to read the CQ ring tail
-- then use __atomic_store(__ATOMIC_RELEASE) to update the CQ ring head
- For submitting entries:
-- first read the SQ ring tail (without any ordering enforcement)
-- then use __atomic_load(__ATOMIC_ACQUIRE) to read the SQ ring head
-- then use __atomic_store(__ATOMIC_RELEASE) to update the SQ ring tail
Wouldn't these be sufficient?!

Thirdly, io_uring.pdf and
https://github.com/torvalds/linux/blob/master/io_uring/io_uring.c seem a
little contradicting, at least from my reading:

io_uring.pdf, in the completion entry example:
- Includes a read_barrier() **BEFORE** it reads the CQ ring tail
- Include a write_barrier() **AFTER** updating CQ head

io_uring.c says on completion entries:
- **AFTER** the application reads the CQ ring tail, it must use an appropriate
  smp_rmb() [...].
- It also needs a smp_mb() **BEFORE** updating CQ head [...].

io_uring.pdf, in the submission entry example:
- Includes a write_barrier() **BEFORE** updating the SQ tail
- Includes a write_barrier() **AFTER** updating the SQ tail

io_uring.c says on submission entries:
- [...] the application must use an appropriate smp_wmb() **BEFORE**
  writing the SQ tail
  (this matches io_uring.pdf)
- And it needs a barrier ordering the SQ head load before writing new
  SQ entries
  
I know, io_uring.pdf does mention that the memory ordering description
is simplified. So maybe this is the whole explanation for my confusion?

Cheers,
  Johann
