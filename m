Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD921404D
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 22:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgGCUXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGCUXX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 16:23:23 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B863C061794
        for <io-uring@vger.kernel.org>; Fri,  3 Jul 2020 13:23:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a6so33954660wrm.4
        for <io-uring@vger.kernel.org>; Fri, 03 Jul 2020 13:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I9348/DFCqwfYI5j4eDz01CT0aWl0Ppw/keZbyzEv94=;
        b=YLivCGRe0YcYYP3/I1L9B7C4dGqazxvX3ksrxoYLGRVL1H1xow+V9DQVm3V33G4w1D
         GxNfOIiz7kAR9i7x2hqRzfD7NCn91LuN8ubzIhnCgv3bPUrHt6glHBvJ8U2Ql6jEVlr2
         /oRIYl34B3CAgmwsVEs6zn+neRbolt7TBBrxAaFOhInulffXrVGWy++IVlE7KE5nfZTN
         hxLOTEUcfjCIaQZdWzlDPj1Qngl0DG6YdlIQk5iVlIC890qKrLACtWZC9fG8s/NsB4jf
         mcX4YzODaqZXz2cViQ2qO1ux5VFN0GmQILZ4FMBlUklUU1VD3xbA0JkGC/U/hQrm01yh
         rOYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I9348/DFCqwfYI5j4eDz01CT0aWl0Ppw/keZbyzEv94=;
        b=lxpLKr1bkW4VB/aRGpRfYFZ8vxj1VWdwD2pd8zp90bsOZ4Bm4EZuPJ0cy/rF3wsxCM
         pMeMkzBVqH+ChYbgrQXySAKxtvde505rkVPXhwFOe9bIQRN770pGI0YEQiRLLRH5Qf+Q
         THPO/coIeO+YKGRZwa31xYad3cYrvuUG01rQcMxvhxhfADwXXy4NdKqPmWmI7EgX3+Yp
         Zy9gYlX8A/NxXFdoh2++MfbhiBg6/OMXWJWLSTF9THbX+rl9sYydLH89FhJPkj66P6YE
         yCh/gChfCvV7HZuIKJudGFzDCVPYf7Q+bH1ALdSNIMkIofns0SQzxyke3kMs80KXuU/v
         R9cQ==
X-Gm-Message-State: AOAM530R7vhYngjx1A3IMMFWFFFKym0smy2xzuL6Fk/reb554sgjLrjl
        h1NiqXDhwdsdpjGd301T5waWIvz7FMnYfFzPQ97Tz2cHUBs=
X-Google-Smtp-Source: ABdhPJwAdvvMaFtG1uiHITOOiSAo/gU5yPgTvEhTeXXPmsR+161u1PUfqTdAU7jwygysGhc9ubNricB5GTUce5tXVts=
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr38483605wru.341.1593807802042;
 Fri, 03 Jul 2020 13:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
 <193a1dc9-6b88-bb23-3cb5-cc72e109f41b@kernel.dk> <CAKq9yRjSewr5z2r8G7dt68RBX4VA9phGpFumKCipNgLzXMdcdQ@mail.gmail.com>
 <e68f971b-8b4a-0cdf-8688-288d6f6da56e@kernel.dk>
In-Reply-To: <e68f971b-8b4a-0cdf-8688-288d6f6da56e@kernel.dk>
From:   Daniele Salvatore Albano <d.albano@gmail.com>
Date:   Fri, 3 Jul 2020 22:22:55 +0200
Message-ID: <CAKq9yRjBUuTPAp7xuRhZ8X+OugiD0gm6LCbr6ZGzwKyG8hmvkw@mail.gmail.com>
Subject: Re: Keep getting the same buffer ID when RECV with IOSQE_BUFFER_SELECT
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000e1f34105a98f4bf5"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--000000000000e1f34105a98f4bf5
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 Jul 2020 at 21:12, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/3/20 1:09 PM, Daniele Salvatore Albano wrote:
> > On Fri, 3 Jul 2020, 20:57 Jens Axboe, <axboe@kernel.dk <mailto:axboe@kernel.dk>> wrote:
> >
> >     On 7/3/20 12:48 PM, Daniele Salvatore Albano wrote:
> >     > Hi,
> >     >
> >     > I have recently started to play with io_uring and liburing but I am
> >     > facing an odd issue, of course initially I thought it was my code but
> >     > after further investigation and testing some other code (
> >     > https://github.com/frevib/io_uring-echo-server/tree/io-uring-op-provide-buffers
> >     > ) I faced the same behaviour.
> >     >
> >     > When using the IOSQE_BUFFER_SELECT with RECV I always get the first
> >     > read right but all the subsequent return a buffer id different from
> >     > what was used by the kernel.
> >     >
> >     > The problem starts to happen only after io_uring_prep_provide_buffers
> >     > is invoked to put back the buffer, the bid set is the one from cflags
> >     >>> 16.
> >     >
> >     > The logic is as follow:
> >     > - io_uring_prep_provide_buffers + io_uring_submit + io_uring_wait_cqe
> >     > initialize all the buffers at the beginning
> >     > - within io_uring_for_each_cqe, when accepting a new connection a recv
> >     > sqe is submitted with the IOSQE_BUFFER_SELECT flag
> >     > - within io_uring_for_each_cqe, when recv a send sqe is submitted
> >     > using as buffer the one specified in cflags >> 16
> >     > - within io_uring_for_each_cqe, when send a provide buffers for the
> >     > bid used to send the data and a recv sqes are submitted.
> >     >
> >     > If I drop io_uring_prep_provide_buffers both in my code and in the
> >     > code I referenced above it just works, but of course at some point
> >     > there are no more buffers available.
> >     >
> >     > To further debug the issue I reduced the amount of provided buffers
> >     > and started to print out the entire bufferset and I noticed that after
> >     > the first correct RECV the kernel stores the data in the first buffer
> >     > of the group id but always returns the last buffer id.
> >     > It is like after calling io_uring_prep_provide_buffers the information
> >     > on the kernel side gets corrupted, I tried to follow the logic on the
> >     > kernel side but there is nothing apparent that would make me
> >     > understand why I am facing this behaviour.
> >     >
> >     > The original author of that code told me on SO that he wrote & tested
> >     > it on the kernel 5.6 + the provide buffers branch, I am facing this
> >     > issue with 5.7.6, 5.8-rc1 and 5.8-rc3. The liburing library is built
> >     > out of the branch, I didn't do too much testing with different
> >     > versions but I tried to figure out where the issue was for the last
> >     > week and within this period I have pulled multiple times the repo.
> >     >
> >     > Any hint or suggestion?
> >
> >     Do you have a simple test case for this that can be run standalone?
> >     I'll take a look, but I'd rather not spend time re-creating a test case
> >     if you already have one.
> >
> >     --
> >     Jens Axboe
> >
> >
> > I will shrink down the code to produce a simple test case but not sure
> > how much code I will be able to lift because it's showing this
> > behaviour on a second recv of a connection so I will need to keep all
> > the boilerplate code to get there.
>
> That's fine, I'm just looking to avoid having to write it from scratch.
> Plus a test case is easier to deal with than trying to write a test case
> based on your description, less room for interpretative errors.
>
> --
> Jens Axboe
>

Hi,

attached the test case, to make it as compact as possible I dropped as
well the error code checking as well.

I have added some fprintf around the code, just connect to localhost
port 5001 using telnet (it will send a line, it will be a bit easier
to check the output).

On the first message you will see a like like
[CQE][RECV] fd 5, cqe flags high: 9, cqe flags low: 1

and a number of lines to show the content of the buffers with the last
buffer containing the message sent via telnet.

On the second message you will instead see again
[CQE][RECV] fd 5, cqe flags high: 5, cqe flags low: 1

but the buffer actually containing the sent line will be the number 0.

On all the successive submits the used buffer will still be 0 but the
high part of cqe->flags will still contain 9.

Or at least this is what I am experiencing.

If you comment out line 110, 111 and 112 it will work as (I think)
expected but of course you will finish the buffers (and get an
undefined behaviour because the code is not managing the errors at
all).


Thanks!
Daniele

--000000000000e1f34105a98f4bf5
Content-Type: application/octet-stream; name="test.c"
Content-Disposition: attachment; filename="test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_kc6nx4cz0>
X-Attachment-Id: f_kc6nx4cz0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0ZGludC5o
PgojaW5jbHVkZSA8bmV0aW5ldC9pbi5oPgoKI2luY2x1ZGUgPGxpYnVyaW5nLmg+CiNpbmNsdWRl
IDxsaWJ1cmluZy9pb191cmluZy5oPgoKI2RlZmluZSBDT05ORUNUSU9OU19CQUNLTE9HIDEwCiNk
ZWZpbmUgQlVGRkVSX0NPVU5UIDEwCiNkZWZpbmUgQlVGRkVSX0xFTiAxMDI0CgplbnVtIHsKICAg
IE9QX0FDQ0VQVCA9IDEsCiAgICBPUF9SRUNWID0gMiwKICAgIE9QX1BST1ZJREVfQlVGRkVSUyA9
IDMsCn07CgpjaGFyIGJ1ZnNbQlVGRkVSX0NPVU5UXVtCVUZGRVJfTEVOXSA9IHswfTsKaW50IHNl
cnZlcl9wb3J0ID0gNTAwMTsKaW50IGJnaWQgPSAxMzM3OwoKaW50IG1haW4oaW50IGFyZ2MsIGNo
YXIgKmFyZ3ZbXSkgewogICAgc3RydWN0IHNvY2thZGRyX2luIHNlcnZfYWRkciA9IHswfSwgY2xp
ZW50X2FkZHIgPSB7MH07CiAgICBzdHJ1Y3QgaW9fdXJpbmdfcGFyYW1zIHBhcmFtcyA9IHswfTsK
ICAgIHN0cnVjdCBpb191cmluZyByaW5nID0gezB9OwogICAgc3RydWN0IGlvX3VyaW5nX3NxZSAq
c3FlOwogICAgc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlOwogICAgY29uc3QgaW50IHZhbCA9IDE7
CiAgICBzb2NrbGVuX3QgY2xpZW50X2xlbiA9IHNpemVvZihjbGllbnRfYWRkcik7CgogICAgaW50
IHNvY2tfbGlzdGVuX2ZkID0gc29ja2V0KEFGX0lORVQsIFNPQ0tfU1RSRUFNIHwgU09DS19OT05C
TE9DSywgMCk7CiAgICBzZXRzb2Nrb3B0KHNvY2tfbGlzdGVuX2ZkLCBTT0xfU09DS0VULCBTT19S
RVVTRUFERFIsICZ2YWwsIHNpemVvZih2YWwpKTsKCiAgICBzZXJ2X2FkZHIuc2luX2ZhbWlseSA9
IEFGX0lORVQ7CiAgICBzZXJ2X2FkZHIuc2luX3BvcnQgPSBodG9ucyhzZXJ2ZXJfcG9ydCk7CiAg
ICBzZXJ2X2FkZHIuc2luX2FkZHIuc19hZGRyID0gSU5BRERSX0FOWTsKCiAgICBiaW5kKHNvY2tf
bGlzdGVuX2ZkLCAoc3RydWN0IHNvY2thZGRyICopICZzZXJ2X2FkZHIsIHNpemVvZihzZXJ2X2Fk
ZHIpKTsKICAgIGxpc3Rlbihzb2NrX2xpc3Rlbl9mZCwgQ09OTkVDVElPTlNfQkFDS0xPRyk7Cgog
ICAgaW9fdXJpbmdfcXVldWVfaW5pdF9wYXJhbXMoMTAyNCwgJnJpbmcsICZwYXJhbXMpOwoKICAg
IC8vIFNldHVwIHRoZSBidWZmZXJzCiAgICBzcWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsK
ICAgIGlvX3VyaW5nX3ByZXBfcHJvdmlkZV9idWZmZXJzKHNxZSwgYnVmcywgQlVGRkVSX0xFTiwg
QlVGRkVSX0NPVU5ULCBiZ2lkLCAwKTsKICAgIGlvX3VyaW5nX3N1Ym1pdCgmcmluZyk7CiAgICBp
b191cmluZ193YWl0X2NxZSgmcmluZywgJmNxZSk7CiAgICBpb191cmluZ19jcWVfc2Vlbigmcmlu
ZywgY3FlKTsKCiAgICAvLyBTdWJtaXQgYW4gYWNjZXB0IHNxZQogICAgc3FlID0gaW9fdXJpbmdf
Z2V0X3NxZSgmcmluZyk7CiAgICBpb191cmluZ19wcmVwX2FjY2VwdChzcWUsIHNvY2tfbGlzdGVu
X2ZkLCAoc3RydWN0IHNvY2thZGRyICopICZjbGllbnRfYWRkciwgJmNsaWVudF9sZW4sIDApOwog
ICAgc3FlLT51c2VyX2RhdGEgPSAoKHVpbnQ4X3QpIE9QX0FDQ0VQVCAmIDB4RkZ1KTsKCiAgICBm
cHJpbnRmKHN0ZG91dCwgIldhaXRpbmcgZm9yIGNvbm5lY3Rpb25zIG9uIHBvcnQgJWRcbiIsIHNl
cnZlcl9wb3J0KTsKICAgIGZmbHVzaChzdGRvdXQpOwoKICAgIC8vIHN0YXJ0IGV2ZW50IGxvb3AK
ICAgIHdoaWxlICgxKSB7CiAgICAgICAgaW9fdXJpbmdfc3VibWl0X2FuZF93YWl0KCZyaW5nLCAx
KTsKICAgICAgICB1bnNpZ25lZCBoZWFkOwogICAgICAgIHVuc2lnbmVkIGNvdW50ID0gMDsKCiAg
ICAgICAgLy8gZ28gdGhyb3VnaCBhbGwgQ1FFcwogICAgICAgIGlvX3VyaW5nX2Zvcl9lYWNoX2Nx
ZSgmcmluZywgaGVhZCwgY3FlKSB7CiAgICAgICAgICAgICsrY291bnQ7CgogICAgICAgICAgICBp
bnQgdHlwZSA9IGNxZS0+dXNlcl9kYXRhICYgMHhGRjsKCiAgICAgICAgICAgIGlmICh0eXBlID09
IE9QX0FDQ0VQVCkgewogICAgICAgICAgICAgICAgaWYgKGNxZS0+cmVzID49IDApIHsKICAgICAg
ICAgICAgICAgICAgICBpbnQgZmQgPSBjcWUtPnJlczsKCiAgICAgICAgICAgICAgICAgICAgc3Fl
ID0gaW9fdXJpbmdfZ2V0X3NxZSgmcmluZyk7CiAgICAgICAgICAgICAgICAgICAgaW9fdXJpbmdf
cHJlcF9yZWN2KHNxZSwgZmQsIE5VTEwsIEJVRkZFUl9MRU4sIDApOwogICAgICAgICAgICAgICAg
ICAgIGlvX3VyaW5nX3NxZV9zZXRfZmxhZ3Moc3FlLCBJT1NRRV9CVUZGRVJfU0VMRUNUKTsKICAg
ICAgICAgICAgICAgICAgICBzcWUtPmJ1Zl9ncm91cCA9IGJnaWQ7CiAgICAgICAgICAgICAgICAg
ICAgc3FlLT51c2VyX2RhdGEgPSAoKGludDY0X3QpIGZkIDw8IDgpIHwgKE9QX1JFQ1YgJiAweEZG
KTsKCiAgICAgICAgICAgICAgICAgICAgZnByaW50ZihzdGRvdXQsICJbQ1FFXVtBQ0NFUFRdIG5l
dyBjb25uZWN0aW9uLCBmZCAlZFxuIiwgZmQpOwogICAgICAgICAgICAgICAgICAgIGZmbHVzaChz
dGRvdXQpOwogICAgICAgICAgICAgICAgfQoKICAgICAgICAgICAgICAgIHNxZSA9IGlvX3VyaW5n
X2dldF9zcWUoJnJpbmcpOwogICAgICAgICAgICAgICAgaW9fdXJpbmdfcHJlcF9hY2NlcHQoc3Fl
LCBzb2NrX2xpc3Rlbl9mZCwgKHN0cnVjdCBzb2NrYWRkciAqKSAmY2xpZW50X2FkZHIsICZjbGll
bnRfbGVuLCAwKTsKICAgICAgICAgICAgICAgIHNxZS0+dXNlcl9kYXRhID0gKE9QX0FDQ0VQVCAm
IDB4RkYpOwogICAgICAgICAgICB9IGVsc2UgaWYgKHR5cGUgPT0gT1BfUkVDVikgewogICAgICAg
ICAgICAgICAgaW50IGZkID0gKGNxZS0+dXNlcl9kYXRhID4+IDgpICYgMHhGRkZGRkZGRjsKICAg
ICAgICAgICAgICAgIGludCBieXRlc19yZWFkID0gY3FlLT5yZXM7CgogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRvdXQsICJbQ1FFXVtSRUNWXSBmZCAlZCwgY3FlIGZsYWdzIGhpZ2g6ICVkLCBj
cWUgZmxhZ3MgbG93OiAlZFxuIiwKICAgICAgICAgICAgICAgICAgICAgICAgZmQsIGNxZS0+Zmxh
Z3MgPj4gMTYsIGNxZS0+ZmxhZ3MgJiAweEZGRkYpOwogICAgICAgICAgICAgICAgZnByaW50Zihz
dGRvdXQsICJbQ1FFXVtSRUNWXSBieXRlczogJWRcbiIsIGJ5dGVzX3JlYWQpOwogICAgICAgICAg
ICAgICAgZmZsdXNoKHN0ZG91dCk7CgogICAgICAgICAgICAgICAgaWYgKGJ5dGVzX3JlYWQgPD0g
MCkgewogICAgICAgICAgICAgICAgICAgIHNodXRkb3duKGZkLCBTSFVUX1JEV1IpOwogICAgICAg
ICAgICAgICAgfSBlbHNlIHsKICAgICAgICAgICAgICAgICAgICBpbnQgYmlkID0gY3FlLT5mbGFn
cyA+PiBJT1JJTkdfQ1FFX0JVRkZFUl9TSElGVDsKCiAgICAgICAgICAgICAgICAgICAgZnByaW50
ZihzdGRvdXQsICJbQ1FFXVtSRUNWXSBtc2c6ICVzXG4iLCBidWZzW2JpZF0pOwogICAgICAgICAg
ICAgICAgICAgIGZmbHVzaChzdGRvdXQpOwoKICAgICAgICAgICAgICAgICAgICBmb3IgKHVpbnQx
Nl90IGkgPSAwOyBpIDwgQlVGRkVSX0NPVU5UOyBpKyspIHsKICAgICAgICAgICAgICAgICAgICAg
ICAgZnByaW50ZihzdGRvdXQsICJbQlVGRkVSXVslZF0gJXNcbiIsIGksIGJ1ZnNbaV0pOwogICAg
ICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgICAgICBmZmx1c2goc3Rkb3V0KTsKCiAg
ICAgICAgICAgICAgICAgICAgc3FlID0gaW9fdXJpbmdfZ2V0X3NxZSgmcmluZyk7CiAgICAgICAg
ICAgICAgICAgICAgaW9fdXJpbmdfcHJlcF9wcm92aWRlX2J1ZmZlcnMoc3FlLCBidWZzLCBCVUZG
RVJfTEVOLCAxLCBiZ2lkLCBiaWQpOwogICAgICAgICAgICAgICAgICAgIHNxZS0+dXNlcl9kYXRh
ID0gKE9QX1BST1ZJREVfQlVGRkVSUyAmIDB4RkYpOwoKICAgICAgICAgICAgICAgICAgICBzcWUg
PSBpb191cmluZ19nZXRfc3FlKCZyaW5nKTsKICAgICAgICAgICAgICAgICAgICBpb191cmluZ19w
cmVwX3JlY3Yoc3FlLCBmZCwgTlVMTCwgQlVGRkVSX0xFTiwgMCk7CiAgICAgICAgICAgICAgICAg
ICAgaW9fdXJpbmdfc3FlX3NldF9mbGFncyhzcWUsIElPU1FFX0JVRkZFUl9TRUxFQ1QpOwogICAg
ICAgICAgICAgICAgICAgIHNxZS0+YnVmX2dyb3VwID0gYmdpZDsKICAgICAgICAgICAgICAgICAg
ICBzcWUtPnVzZXJfZGF0YSA9ICgoaW50NjRfdCkgZmQgPDwgOCkgfCAoT1BfUkVDViAmIDB4RkYp
OwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAg
ZnByaW50ZihzdGRvdXQsICJbQ1FFXVtPVEhFUl0gaWdub3JpbmdcbiIpOwogICAgICAgICAgICAg
ICAgZmZsdXNoKHN0ZG91dCk7CiAgICAgICAgICAgIH0KICAgICAgICB9CgogICAgICAgIGlvX3Vy
aW5nX2NxX2FkdmFuY2UoJnJpbmcsIGNvdW50KTsKICAgIH0KfQo=
--000000000000e1f34105a98f4bf5--
