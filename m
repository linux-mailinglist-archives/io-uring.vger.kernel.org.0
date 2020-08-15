Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D9824521C
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHOVnV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgHOVnV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:43:21 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F12C03D1C5
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 14:43:20 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o22so9651632qtt.13
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 14:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A2pjSIi0V+WxuISit7Z3mDAAp/laGecQN3RIlMayV1g=;
        b=l9tfmPjYmJjjZtS1G0ArsTl0ihOWkhMfT8yQtyXT/lXcYiyq4yb54ITB+qWy4gW6m9
         wKXqXdyVNjBhrgqg+sTMPp/aB6AVPg0G/eTEp24sWg5R+dG4b9SEi2P4u/bQbbil+8T4
         Xl/MXAY+V9Guh34exIri9+vTYrr2CPGiA5VdMpJN7XbvY4fq5emVqX2gEuokwtx+PBxq
         pWuMOMtnpM2zRMX+lM7/EmvNkdiC81em2PGD6vtKx95nLSbdoHOt247CjI6GV7BcVhgb
         hWS4Qn9Z6YMMFHl7HFoj1Zm7unA8A9GQnOb/p5DAxyPpELIGlciLyzsnM/yTqx8gN/DF
         ytHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A2pjSIi0V+WxuISit7Z3mDAAp/laGecQN3RIlMayV1g=;
        b=B+AAGDo0taNnVPQg3+vhfVPlvLibPu3/W8+lr8S6FXEoCh6zEBeXpfh4LPlFgRkma7
         Vmz8xtOpgG2CvNQcFArFHiUbaoIvVN10d9AqBHjMZhL8d1i28O/JeK4quWJJT7wZum8G
         37kfAw7gpj80675fowQXuOkYFsD1VmVC7wwRPcFE8N2F/hpOXoNWH+xiLIav3uvB19at
         p8sZ3loDkt4a2y97yAD6bIAhTWYYlY3QOuZZ9iAn+YffyisAIBCMI3h5bSt2vqRzzJE7
         zhVeEqQhTd/MDVG8n7BJPxPYVYKR62RtyhJmK7Vo+eZciPhN0IcNBfr0atIbDlHkSPnh
         oHUA==
X-Gm-Message-State: AOAM533nWJnrUc2psg4lvt1Vc58ACs5SadpxEXQnAMND6dYJDbReuDQt
        zcdJI0FYMOKSBsCTo5a/FYQ1eRMNjGqj1ucu7Bo=
X-Google-Smtp-Source: ABdhPJzRbxKI+sUoHwdYVDTfNfVjFnUb09CIqjszujfmwB09WY0c6J7TlMCkUUiZmFz/A8sqJX/M7bRQnQFBaZa8n5c=
X-Received: by 2002:ac8:4b4d:: with SMTP id e13mr7536382qts.256.1597527799812;
 Sat, 15 Aug 2020 14:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk> <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com> <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk> <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk> <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
In-Reply-To: <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Sat, 15 Aug 2020 23:43:08 +0200
Message-ID: <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
Subject: Re: io_uring process termination/killing is not working
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: multipart/mixed; boundary="00000000000006f59c05acf16dbe"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--00000000000006f59c05acf16dbe
Content-Type: text/plain; charset="UTF-8"

it seems to be that read event doesn't work properly, but I'm not sure
if it is related to what Pavel mentioned
poll<link>accept works but not poll<link>read -> cqe still receives
poll event but no read event, however I received a read event after
the third request via telnet

I just tested https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=io_uring-5.9&id=d4e7cd36a90e38e0276d6ce0c20f5ccef17ec38c
and
https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=io_uring-5.9&id=227c0c9673d86732995474d277f84e08ee763e46
(but it works on Linux 5.7)


On Sat, 15 Aug 2020 at 18:50, Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 15/08/2020 18:12, Jens Axboe wrote:
> > On 8/15/20 12:45 AM, Pavel Begunkov wrote:
> >> On 13/08/2020 02:32, Jens Axboe wrote:
> >>> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
> >>>> On 12/08/2020 21:22, Pavel Begunkov wrote:
> >>>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
> >>>>>> On 12/08/2020 21:05, Jens Axboe wrote:
> >>>>>>> On 8/12/20 11:58 AM, Josef wrote:
> >>>>>>>> Hi,
> >>>>>>>>
> >>>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
> >>>>>>>> doesn't work to kill this process(always state D or D+), literally I
> >>>>>>>> have to terminate my VM because even the kernel can't kill the process
> >>>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
> >>>>>>>> works
> >>>>>>>>
> >>>>>>>> I've attached a file to reproduce it
> >>>>>>>> or here
> >>>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
> >>>>>>>
> >>>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
> >>>>>>> state, which is why you can't kill it.
> >>>>>>
> >>>>>> It looks like one of the hangs I've been talking about a few days ago,
> >>>>>> an accept is inflight but can't be found by cancel_files() because it's
> >>>>>> in a link.
> >>>>>
> >>>>> BTW, I described it a month ago, there were more details.
> >>>>
> >>>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
> >>>
> >>> Yeah I think you're right. How about something like the below? That'll
> >>> potentially cancel more than just the one we're looking for, but seems
> >>> kind of silly to only cancel from the file table holding request and to
> >>> the end.
> >>
> >> The bug is not poll/t-out related, IIRC my test reproduces it with
> >> read(pipe)->open(). See the previously sent link.
> >
> > Right, but in this context for poll, I just mean any request that has a
> > poll handler armed. Not necessarily only a pure poll. The patch should
> > fix your case, too.
>
> Ok. I was thinking about sleeping in io_read(), etc. from io-wq context.
> That should have the same effect.
>
> >
> >> As mentioned, I'm going to patch that up, if you won't beat me on that.
> >
> > Please test and send a fix if you find something! I'm going to ship what
> > I have this weekend, but we can always add a fix on top if we need
> > anything.
>
> Sure
>
> --
> Pavel Begunkov

--
Josef Grieb

--00000000000006f59c05acf16dbe
Content-Type: application/octet-stream; name="io_uring_read_issue.c"
Content-Disposition: attachment; filename="io_uring_read_issue.c"
Content-Transfer-Encoding: base64
Content-ID: <f_kdw6o1l60>
X-Attachment-Id: f_kdw6o1l60

I2luY2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8bmV0aW5ldC9p
bi5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3Ry
aW5nLmg+CiNpbmNsdWRlIDxzdHJpbmdzLmg+CiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+CiNpbmNs
dWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPHBvbGwuaD4KI2luY2x1ZGUgImxpYnVyaW5nLmgiCgoj
ZGVmaW5lIEJBQ0tMT0cgNTEyCgojZGVmaW5lIFBPUlQgOTMwMAoKc3RydWN0IGlvX3VyaW5nIHJp
bmc7CgpjaGFyIGJ1ZlsxMDBdOwoKdm9pZCBhZGRfcG9sbChpbnQgZmQpIHsKICAgIHN0cnVjdCBp
b191cmluZ19zcWUgKnNxZSA9IGlvX3VyaW5nX2dldF9zcWUoJnJpbmcpOwogICAgaW9fdXJpbmdf
cHJlcF9wb2xsX2FkZChzcWUsIGZkLCBQT0xMSU4pOwogICAgc3FlLT51c2VyX2RhdGEgPSAxOwog
ICAgc3FlLT5mbGFncyB8PSBJT1NRRV9JT19MSU5LOwp9Cgp2b2lkIGFkZF9hY2NlcHQoaW50IGZk
KSB7CiAgICBzdHJ1Y3QgaW9fdXJpbmdfc3FlICpzcWUgPSBpb191cmluZ19nZXRfc3FlKCZyaW5n
KTsKICAgIGlvX3VyaW5nX3ByZXBfYWNjZXB0KHNxZSwgZmQsIDAsIDAsIFNPQ0tfTk9OQkxPQ0sg
fCBTT0NLX0NMT0VYRUMpOwogICAgc3FlLT51c2VyX2RhdGEgPSAyOwogICAgc3FlLT5mbGFncyB8
PSBJT1NRRV9JT19MSU5LOwp9Cgp2b2lkIGFkZF9yZWFkKGludCBmZCkgewogICAgc3RydWN0IGlv
X3VyaW5nX3NxZSAqc3FlID0gaW9fdXJpbmdfZ2V0X3NxZSgmcmluZyk7CiAgICBpb191cmluZ19w
cmVwX3JlYWQoc3FlLCBmZCwgJmJ1ZiwgMTAwLCAwKTsKICAgIHNxZS0+dXNlcl9kYXRhID0gMzsK
ICAgIHNxZS0+ZmxhZ3MgfD0gSU9TUUVfSU9fTElOSzsKfQoKaW50IHNldHVwX2lvX3VyaW5nKCkg
ewogICAgaW50IHJldCA9IGlvX3VyaW5nX3F1ZXVlX2luaXQoMTYsICZyaW5nLCAwKTsKICAgIGlm
IChyZXQpIHsKICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIlVuYWJsZSB0byBzZXR1cCBpb191cmlu
ZzogJXNcbiIsIHN0cmVycm9yKC1yZXQpKTsKICAgICAgICByZXR1cm4gMTsKICAgIH0KICAgIHJl
dHVybiAwOwp9CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqYXJndltdKSB7CgogICAgc3RydWN0
IHNvY2thZGRyX2luIHNlcnZfYWRkcjsKCiAgICBzZXR1cF9pb191cmluZygpOwogICAgCiAgICBp
bnQgc29ja19saXN0ZW5fZmQgPSBzb2NrZXQoQUZfSU5FVCwgU09DS19TVFJFQU0gfCBTT0NLX05P
TkJMT0NLLCAwKTsKICAgIGNvbnN0IGludCB2YWwgPSAxOwogICAgc2V0c29ja29wdChzb2NrX2xp
c3Rlbl9mZCwgU09MX1NPQ0tFVCwgU09fUkVVU0VBRERSLCAmdmFsLCBzaXplb2YodmFsKSk7Cgog
ICAgbWVtc2V0KCZzZXJ2X2FkZHIsIDAsIHNpemVvZihzZXJ2X2FkZHIpKTsKICAgIHNlcnZfYWRk
ci5zaW5fZmFtaWx5ID0gQUZfSU5FVDsKICAgIHNlcnZfYWRkci5zaW5fcG9ydCA9IGh0b25zKFBP
UlQpOwogICAgc2Vydl9hZGRyLnNpbl9hZGRyLnNfYWRkciA9IElOQUREUl9BTlk7CgogICAgaWYg
KGJpbmQoc29ja19saXN0ZW5fZmQsIChzdHJ1Y3Qgc29ja2FkZHIgKikmc2Vydl9hZGRyLCBzaXpl
b2Yoc2Vydl9hZGRyKSkgPCAwKSB7CiAgICAgICAgIHBlcnJvcigiRXJyb3IgYmluZGluZyBzb2Nr
ZXRcbiIpOwogICAgICAgICBleGl0KDEpOwogICAgIH0KICAgIGlmIChsaXN0ZW4oc29ja19saXN0
ZW5fZmQsIEJBQ0tMT0cpIDwgMCkgewogICAgICAgICBwZXJyb3IoIkVycm9yIGxpc3RlbmluZyBv
biBzb2NrZXRcbiIpOwogICAgICAgICBleGl0KDEpOwogICAgfQoKICAgIHNldHVwX2lvX3VyaW5n
KCk7CgogICAgYWRkX3BvbGwoc29ja19saXN0ZW5fZmQpOwogICAgYWRkX2FjY2VwdChzb2NrX2xp
c3Rlbl9mZCk7CiAgICBpb191cmluZ19zdWJtaXQoJnJpbmcpOwoKICAgIHdoaWxlICgxKSB7CiAg
ICAgICAgc3RydWN0IGlvX3VyaW5nX2NxZSAqY3FlOwogICAgICAgIGlvX3VyaW5nX3dhaXRfY3Fl
KCZyaW5nLCAmY3FlKTsKCiAgICAgICAgcHJpbnRmKCJSZXM6IHJlczogJWRcbiIsIGNxZS0+cmVz
KTsKICAgICAgICAKICAgICAgICBpZiAoY3FlLT51c2VyX2RhdGEgPT0gMSkgewogICAgICAgICAg
ICBwcmludGYoIlBvbGwgRXZlbnRcbiIpOwogICAgICAgIH0KICAgICAgICAKICAgICAgICBpZiAo
Y3FlLT51c2VyX2RhdGEgPT0gMiAmJiBjcWUtPnJlcyA+IDApIHsKICAgICAgICAgICAgcHJpbnRm
KCJBY2NlcHQgRXZlbnRcbiIpOwogICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICBhZGRf
cG9sbChzb2NrX2xpc3Rlbl9mZCk7CiAgICAgICAgICAgIGFkZF9hY2NlcHQoc29ja19saXN0ZW5f
ZmQpOwoKICAgICAgICAgICAgLy9hdm9pZCBsaW5rIGJldHdlZW4gYWRkX2FjY2VwdCBhbmQgYWRk
X3BvbGwKICAgICAgICAgICAgc3RydWN0IGlvX3VyaW5nX3NxZSAqc3FlID0gaW9fdXJpbmdfZ2V0
X3NxZSgmcmluZyk7CiAgICAgICAgICAgIGlvX3VyaW5nX3ByZXBfbm9wKHNxZSk7IAoKICAgICAg
ICAgICAgYWRkX3BvbGwoY3FlLT5yZXMpOwogICAgICAgICAgICBhZGRfcmVhZChjcWUtPnJlcyk7
CiAgICAgICAgfQoKICAgICAgICBpZiAoY3FlLT51c2VyX2RhdGEgPT0gMykgewogICAgICAgICAg
ICBwcmludGYoIlJlYWQgQnVmOiAlcyBcbiIsIGJ1Zik7CiAgICAgICAgfQogICAgICAgIGlvX3Vy
aW5nX3N1Ym1pdCgmcmluZyk7CgogICAgICAgIGlvX3VyaW5nX2NxZV9zZWVuKCZyaW5nLCBjcWUp
OwogICAgfQoKICAgIGlvX3VyaW5nX3F1ZXVlX2V4aXQoJnJpbmcpOwoKICAgIHJldHVybiAwOwp9
--00000000000006f59c05acf16dbe--
