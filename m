Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112653EA646
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 16:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhHLONl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 10:13:41 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:44214 "EHLO
        mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhHLONk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 10:13:40 -0400
X-ASG-Debug-ID: 1628776402-0fb3b001bfc4d60001-k4Lu3k
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id lkPLFyzvNeBjB96l; Thu, 12 Aug 2021 09:53:22 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
        bh=3MG1Vac5wpnbY+5A5viqd1Gyo97myoZFxF6zv1w1+9g=;
        h=Content-Language:Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; b=RX51K6U8xQlg+QN
        RLNyr5dNvKZR8TdbhL3l3evZdmekmZqhoPPh/QXcmu9csGzrZ5A1LPJwcA8/9ovJUJW5UWgzVPibx
        z2td/2OUHibvIHBsteTfSXpOTuGOHIDcwDBAf+STR9mwmY8WTDPCp4MX9ef9CJiMsi5d2/oceFLgX
        Fg=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate Pro SMTP 6.2.14)
  with ESMTPS id 11066215; Thu, 12 Aug 2021 09:53:22 -0400
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
To:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH] coredump: Limit what can interrupt coredumps
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
 <87pmwmn5m0.fsf@disp2133>
 <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
 <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
 <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
From:   Tony Battersby <tonyb@cybernetics.com>
Message-ID: <7b201ca7-dd1d-61be-8586-5dbf7a3c9333@cybernetics.com>
Date:   Thu, 12 Aug 2021 09:53:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1628776402
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 1053
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/21 9:55 PM, Jens Axboe wrote:
>
> That is very interesting. Like Olivier mentioned, it's not that actual
> commit, but rather the change of behavior implemented by it. Before that
> commit, we'd hit the async workers more often, whereas after we do the
> correct retry method where it's driven by the wakeup when the page is
> unlocked. This is purely speculation, but perhaps the fact that the
> process changes state potentially mid dump is why the dump ends up being
> truncated?
>
> I'd love to dive into this and try and figure it out. Absent a test
> case, at least the above gives me an idea of what to try out. I'll see
> if it makes it easier for me to create a case that does result in a
> truncated core dump.
>
If it helps, a "good" coredump from my program is about 350 MB
compressed down to about 7 MB by bzip2.  A truncated coredump varies in
size from about 60 KB to about 2 MB before compression.  The program
that receives the coredump uses bzip2 to compress the data before
writing it to disk.

Tony

