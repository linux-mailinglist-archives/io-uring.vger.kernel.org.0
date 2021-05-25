Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56D03909D6
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 21:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhEYTqp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 May 2021 15:46:45 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:50640 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhEYTqo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 May 2021 15:46:44 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:52978 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1llczI-0005mz-RT; Tue, 25 May 2021 15:45:12 -0400
Message-ID: <b4a669191a5a5d1bc9e900991a1b34c9d245e36f.camel@trillion01.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Date:   Tue, 25 May 2021 15:45:11 -0400
In-Reply-To: <d9a12052074ba194fe0764c932603a5f85c5445a.camel@trillion01.com>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
         <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
         <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
         <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
         <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
         <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk>
         <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
         <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
         <8735v3jujv.ffs@nanos.tec.linutronix.de>
         <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
         <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org>
         <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
         <59ea3b5a-d7b3-b62e-cc83-1f32a83c4ac2@kernel.dk>
         <17471c9fec18765449ef3a5a4cddc23561b97f52.camel@trillion01.com>
         <CAHk-=whoJCocFsQ7+Sqq=dkuzHE+RXxvRdd4ZvyYqnsKBqsKAA@mail.gmail.com>
         <3df541c3-728c-c63d-eaeb-a4c382e01f0b@kernel.dk>
         <b360ed542526da0a510988ce30545f429a7da000.camel@trillion01.com>
         <4390e9fb839ebc0581083fc4fa7a82606432c0c0.camel@trillion01.com>
         <d9a12052074ba194fe0764c932603a5f85c5445a.camel@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2021-05-25 at 15:39 -0400, Olivier Langlois wrote:
> This notion appears to be central when creating a coredump...
> Only tasks having the same mm than the one receiving the SIGSEGV will
> be zapped...
> 
> in zap_threads():
>                 for_each_thread(g, p) {
>                         if (unlikely(!p->mm))
>                                 continue;
>                         if (unlikely(p->mm == mm)) {
>                                 lock_task_sighand(p, &flags);
>                                 nr += zap_process(p, exit_code,
>                                                         SIGNAL_GROUP_
> E
> XIT);
>                                 unlock_task_sighand(p, &flags);
>                         }
>                         break;
>                 }

without fully understanding what I am doing... I am tempted to tweak
the condition

(unlikely(p->mm == mm))

for

(unlikely(p->mm == mm || p->flags & PF_IO_WORKER))

and see if it would resolve my coredump problem...


