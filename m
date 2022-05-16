Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059C052882F
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiEPPNZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 11:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiEPPNZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 11:13:25 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418533BA4F;
        Mon, 16 May 2022 08:13:23 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 22C0F32009A4;
        Mon, 16 May 2022 11:13:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 16 May 2022 11:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=living180.net;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1652713998; x=1652800398; bh=pF
        px6s6xSAKeva4U1SNHToO95r+skF7Rt6MVqTJ7kH0=; b=e3YRB0mi++usMJCdXO
        FBn/tf8thlTwv0TuOQhcXUgSuv8DObW+fI5kAhJWKgJqrPss6NklLMop5lfcpSpo
        LXpOTQ2L8jDn78Z8gOMA58ryO3HflBcfQ0d6+cx/tNzlQBX7TAid1k7SuDI+AQP2
        +txonLHKM5dOcesmk63pkdz4PhDn7LJ2jWBs1HcGxwNbuMRddX6FTGKkmtjydM0X
        TNravLQyiAs+p0sHY5fBvEFxu/GyHVD/sFYvOp2sijE0h+gx6R9LatUDYGslRy9i
        FR1EcDshnxKNoNkTjQY3Ca22dfyB2KPW+6n9jAuaHn14fbhAsIot0R0emVHYMzmF
        FHQA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652713998; x=
        1652800398; bh=pFpx6s6xSAKeva4U1SNHToO95r+skF7Rt6MVqTJ7kH0=; b=v
        aZBnb++DG5HrzIdDz4Djso2hctsrnCUDjaxsoq0TfAJePFsnlEmG5ic8i1aKV3jv
        ADXHd1gGBYmRPso72tIx+OeosfaqYtzsNcYDXsfaioluWKYG5Qc8CMvk/9PET6E1
        wjwxJWbyAVQ3hMzcMMbesEPQpuzQQ8NrZ8BrNWfVVIHqmIuo7Gw+XwYRVdJSIuOS
        eXgpkcHEpdFVbf1efbEASGDq6E9x5KoQzDhnwR+pvqO769Ia623O1lCSCH+qiXBo
        46zIP17RIZQeV9QVUiSMqu7qnsss8obOUHYRd/FNRbbJ7t34+O0kH+eeuErWAtQc
        7B1m9P78vpiRWXBWfAoDw==
X-ME-Sender: <xms:DmqCYhzD-xW6e682k0M5ytPaw-1skj2Oxn6wEk0eBeu8uEIkNe_g9A>
    <xme:DmqCYhRXQ_swtDzPKdc2KReNH6UxU45-TlxvTRQYOu7z9aUd0El9wtIQBgOJwe1B3
    r_Buz32Osn-xA>
X-ME-Received: <xmr:DmqCYrVjuBFDaTi07g-BHa58qsMwjoDdbW_tHTx5qJnPzgyxLbY7H-rwWldYQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrheehgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpegtkfffgggfuffhvfevfhgjsehmtderredtfeejnecuhfhrohhmpeffrghnihgv
    lhcujfgrrhguihhnghcuoeguhhgrrhguihhngheslhhivhhinhhgudektddrnhgvtheqne
    cuggftrfgrthhtvghrnhepudejudfhueeitdelledugfefueehtdfgtefhheeuiefgiefh
    teelteekgeeigfehnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguhhgrrhguihhngheslhhi
    vhhinhhgudektddrnhgvth
X-ME-Proxy: <xmx:DmqCYjh-1lpKuwG8kGdkaBadLp4jJ7qd6F7hi30bX2I2RyTm5OsZfg>
    <xmx:DmqCYjDSnYrUDIe16WunWI2GJHF41aZV6r1BwLTzqM9WfY0Etfoa7w>
    <xmx:DmqCYsI6MLUL9ics3t0NDQBr3UGabi3EyjDcekyxu0Y2lS80b2c40Q>
    <xmx:DmqCYu4Zc3_blg5zL32afXhmoeWGCTTrG8uc0TXwUD4foBweDiUSEw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 May 2022 11:13:16 -0400 (EDT)
Content-Type: multipart/mixed; boundary="------------Yb4lpw6XJqcdFybbm0AXJO0G"
Message-ID: <13028ff4-3565-f09e-818c-19e5f95fa60f@living180.net>
Date:   Mon, 16 May 2022 18:13:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
From:   Daniel Harding <dharding@living180.net>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
 <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
 <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
 <fb0dbd71-9733-0208-48f2-c5d22ed17510@gmail.com>
 <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
 <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
 <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
 <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
 <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
 <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
 <da56fa5f-0624-413e-74a1-545993940d27@gmail.com>
 <3fc08243-f9e0-9cec-4207-883c55ccff78@living180.net>
In-Reply-To: <3fc08243-f9e0-9cec-4207-883c55ccff78@living180.net>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------Yb4lpw6XJqcdFybbm0AXJO0G
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/16/22 16:57, Daniel Harding wrote:
> On 5/16/22 16:25, Pavel Begunkov wrote:
>> On 5/16/22 13:12, Pavel Begunkov wrote:
>>> On 5/15/22 19:34, Daniel Harding wrote:
>>>> On 5/15/22 11:20, Thorsten Leemhuis wrote:
>>>>> On 04.05.22 08:54, Daniel Harding wrote:
>>>>>> On 5/3/22 17:14, Pavel Begunkov wrote:
>>>>>>> On 5/3/22 08:37, Daniel Harding wrote:
>>>>>>>> [Resend with a smaller trace]
>>>>>>>> On 5/3/22 02:14, Pavel Begunkov wrote:
>>>>>>>>> On 5/2/22 19:49, Daniel Harding wrote:
>>>>>>>>>> On 5/2/22 20:40, Pavel Begunkov wrote:
>>>>>>>>>>> On 5/2/22 18:00, Jens Axboe wrote:
>>>>>>>>>>>> On 5/2/22 7:59 AM, Jens Axboe wrote:
>>>>>>>>>>>>> On 5/2/22 7:36 AM, Daniel Harding wrote:
>>>>>>>>>>>>>> On 5/2/22 16:26, Jens Axboe wrote:
>>>>>>>>>>>>>>> On 5/2/22 7:17 AM, Daniel Harding wrote:
>>>>>>>>>>>>>>>> I use lxc-4.0.12 on Gentoo, built with io-uring support
>>>>>>>>>>>>>>>> (--enable-liburing), targeting liburing-2.1.  My kernel
>>>>>>>>>>>>>>>> config is a
>>>>>>>>>>>>>>>> very lightly modified version of Fedora's generic kernel
>>>>>>>>>>>>>>>> config. After
>>>>>>>>>>>>>>>> moving from the 5.16.x series to the 5.17.x kernel 
>>>>>>>>>>>>>>>> series, I
>>>>>>>>>>>>>>>> started
>>>>>>>>>>>>>>>> noticed frequent hangs in lxc-stop. It doesn't happen 100%
>>>>>>>>>>>>>>>> of the
>>>>>>>>>>>>>>>> time, but definitely more than 50% of the time. Bisecting
>>>>>>>>>>>>>>>> narrowed
>>>>>>>>>>>>>>>> down the issue to commit
>>>>>>>>>>>>>>>> aa43477b040251f451db0d844073ac00a8ab66ee:
>>>>>>>>>>>>>>>> io_uring: poll rework. Testing indicates the problem is 
>>>>>>>>>>>>>>>> still
>>>>>>>>>>>>>>>> present
>>>>>>>>>>>>>>>> in 5.18-rc5. Unfortunately I do not have the expertise 
>>>>>>>>>>>>>>>> with the
>>>>>>>>>>>>>>>> codebases of either lxc or io-uring to try to debug the 
>>>>>>>>>>>>>>>> problem
>>>>>>>>>>>>>>>> further on my own, but I can easily apply patches to 
>>>>>>>>>>>>>>>> any of the
>>>>>>>>>>>>>>>> involved components (lxc, liburing, kernel) and rebuild 
>>>>>>>>>>>>>>>> for
>>>>>>>>>>>>>>>> testing or
>>>>>>>>>>>>>>>> validation.  I am also happy to provide any further
>>>>>>>>>>>>>>>> information that
>>>>>>>>>>>>>>>> would be helpful with reproducing or debugging the 
>>>>>>>>>>>>>>>> problem.
>>>>>>>>>>>>>>> Do you have a recipe to reproduce the hang? That would 
>>>>>>>>>>>>>>> make it
>>>>>>>>>>>>>>> significantly easier to figure out.
>>>>>>>>>>>>>> I can reproduce it with just the following:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>       sudo lxc-create --n lxc-test --template download 
>>>>>>>>>>>>>> --bdev
>>>>>>>>>>>>>> dir --dir /var/lib/lxc/lxc-test/rootfs -- -d ubuntu -r 
>>>>>>>>>>>>>> bionic
>>>>>>>>>>>>>> -a amd64
>>>>>>>>>>>>>>       sudo lxc-start -n lxc-test
>>>>>>>>>>>>>>       sudo lxc-stop -n lxc-test
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The lxc-stop command never exits and the container continues
>>>>>>>>>>>>>> running.
>>>>>>>>>>>>>> If that isn't sufficient to reproduce, please let me know.
>>>>>>>>>>>>> Thanks, that's useful! I'm at a conference this week and 
>>>>>>>>>>>>> hence have
>>>>>>>>>>>>> limited amount of time to debug, hopefully Pavel has time to
>>>>>>>>>>>>> take a look
>>>>>>>>>>>>> at this.
>>>>>>>>>>>> Didn't manage to reproduce. Can you try, on both the good 
>>>>>>>>>>>> and bad
>>>>>>>>>>>> kernel, to do:
>>>>>>>>>>> Same here, it doesn't reproduce for me
>>>>>>>>>> OK, sorry it wasn't something simple.
>>>>>>>>>>> # echo 1 > /sys/kernel/debug/tracing/events/io_uring/enable
>>>>>>>>>>>> run lxc-stop
>>>>>>>>>>>>
>>>>>>>>>>>> # cp /sys/kernel/debug/tracing/trace ~/iou-trace
>>>>>>>>>>>>
>>>>>>>>>>>> so we can see what's going on? Looking at the source, lxc 
>>>>>>>>>>>> is just
>>>>>>>>>>>> using
>>>>>>>>>>>> plain POLL_ADD, so I'm guessing it's not getting a 
>>>>>>>>>>>> notification
>>>>>>>>>>>> when it
>>>>>>>>>>>> expects to, or it's POLL_REMOVE not doing its job. If we 
>>>>>>>>>>>> have a
>>>>>>>>>>>> trace
>>>>>>>>>>>> from both a working and broken kernel, that might shed some 
>>>>>>>>>>>> light
>>>>>>>>>>>> on it.
>>>>>>>>>> It's late in my timezone, but I'll try to work on getting those
>>>>>>>>>> traces tomorrow.
>>>>>>>>> I think I got it, I've attached a trace.
>>>>>>>>>
>>>>>>>>> What's interesting is that it issues a multi shot poll but I 
>>>>>>>>> don't
>>>>>>>>> see any kind of cancellation, neither cancel requests nor 
>>>>>>>>> task/ring
>>>>>>>>> exit. Perhaps have to go look at lxc to see how it's supposed
>>>>>>>>> to work
>>>>>>>> Yes, that looks exactly like my bad trace.  I've attached good 
>>>>>>>> trace
>>>>>>>> (captured with linux-5.16.19) and a bad trace (captured with
>>>>>>>> linux-5.17.5).  These are the differences I noticed with just a
>>>>>>>> visual scan:
>>>>>>>>
>>>>>>>> * Both traces have three io_uring_submit_sqe calls at the very
>>>>>>>> beginning, but in the good trace, there are further
>>>>>>>> io_uring_submit_sqe calls throughout the trace, while in the bad
>>>>>>>> trace, there are none.
>>>>>>>> * The good trace uses a mask of c3 for io_uring_task_add much more
>>>>>>>> often than the bad trace:  the bad trace uses a mask of c3 only 
>>>>>>>> for
>>>>>>>> the very last call to io_uring_task_add, but a mask of 41 for the
>>>>>>>> other calls.
>>>>>>>> * In the good trace, many of the io_uring_complete calls have a
>>>>>>>> result of 195, while in the bad trace, they all have a result 
>>>>>>>> of 1.
>>>>>>>>
>>>>>>>> I don't know whether any of those things are significant or 
>>>>>>>> not, but
>>>>>>>> that's what jumped out at me.
>>>>>>>>
>>>>>>>> I have also attached a copy of the script I used to generate the
>>>>>>>> traces.  If there is anything further I can to do help debug, 
>>>>>>>> please
>>>>>>>> let me know.
>>>>>>> Good observations! thanks for traces.
>>>>>>>
>>>>>>> It sounds like multi-shot poll requests were getting downgraded
>>>>>>> to one-shot, which is a valid behaviour and was so because we
>>>>>>> didn't fully support some cases. If that's the reason, than
>>>>>>> the userspace/lxc is misusing the ABI. At least, that's the
>>>>>>> working hypothesis for now, need to check lxc.
>>>>>> So, I looked at the lxc source code, and it appears to at least 
>>>>>> try to
>>>>>> handle the case of multi-shot being downgraded to one-shot.  I don't
>>>>>> know enough to know if the code is actually correct however:
>>>>>>
>>>>>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L165-L189 
>>>>>>
>>>>>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L254 
>>>>>>
>>>>>> https://github.com/lxc/lxc/blob/7e37cc96bb94175a8e351025d26cc35dc2d10543/src/lxc/mainloop.c#L288-L290 
>>>>>>
>>>>> Hi, this is your Linux kernel regression tracker. Nothing happened 
>>>>> here
>>>>> for round about ten days now afaics; or did the discussion continue
>>>>> somewhere else.
>>>>>
>>>>>  From what I gathered from this discussion is seems the root cause 
>>>>> might
>>>>> be in LXC, but it was exposed by kernel change. That makes it sill a
>>>>> kernel regression that should be fixed; or is there a strong 
>>>>> reason why
>>>>> we should let this one slip?
>>>>
>>>> No, there hasn't been any discussion since the email you replied 
>>>> to. I've done a bit more testing on my end, but without anything 
>>>> conclusive.  The one thing I can say is that my testing shows that 
>>>> LXC does correctly handle multi-shot poll requests which were being 
>>>> downgraded to one-shot in 5.16.x kernels, which I think invalidates 
>>>> Pavel's theory.  In 5.17.x kernels, those same poll requests are no 
>>>> longer being downgraded to one-shot requests, and thus under 5.17.x 
>>>> LXC is no longer re-arming those poll requests (but also shouldn't 
>>>> need to, according to what is being returned by the kernel). I 
>>>> don't know if this change in kernel behavior is related to the 
>>>> hang, or if it is just a side effect of other io-uring changes that 
>>>> made it into 5.17.  Nothing in the LXC's usage of io-uring seems 
>>>> obviously incorrect to me, but I am far from an expert.  I also did 
>>>> some work toward creating a simpler reproducer, without success (I 
>>>> was able to get a simple program using io-uring running, but never 
>>>> could get it to hang).  ISTM that this is still a kernel 
>>>> regression, unless someone can point out a definite fault in the 
>>>> way LXC is using io-uring.
>>>
>>> Haven't had time to debug it. Apparently LXC is stuck on
>>> read(2) terminal fd. Not yet clear what is the reason.
>>
>> How it was with oneshots:
>>
>> 1: kernel: poll fires, add a CQE
>> 2: kernel: remove poll
>> 3: userspace: get CQE
>> 4: userspace: read(terminal_fd);
>> 5: userspace: add new poll
>> 6: goto 1)
>>
>> What might happen and actually happens with multishot:
>>
>> 1: kernel: poll fires, add CQE1
>> 2: kernel: poll fires again, add CQE2
>> 3: userspace: get CQE1
>> 4: userspace: read(terminal_fd); // reads all data, for both CQE1 and 
>> CQE2
>> 5: userspace: get CQE2
>> 6: userspace: read(terminal_fd); // nothing to read, hangs here
>>
>> It should be the read in lxc_terminal_ptx_io().
>>
>> IMHO, it's not a regression but a not perfect feature API and/or
>> an API misuse.
>>
>> Cc: Christian Brauner
>>
>> Christian, in case you may have some input on the LXC side of things.
>> Daniel reported an LXC problem when it uses io_uring multishot poll 
>> requests.
>> Before aa43477b04025 ("io_uring: poll rework"), multishot poll 
>> requests for
>> tty/pty and some other files were always downgraded to oneshots, 
>> which had
>> been fixed by the commit and exposed the problem. I hope the example 
>> above
>> explains it, but please let me know if it needs more details
>
> Pavel, I had actually just started a draft email with the same theory 
> (although you stated it much more clearly than I could have).  I'm 
> working on debugging the LXC side, but I'm pretty sure the issue is 
> due to LXC using blocking reads and getting stuck exactly as you 
> describe.  If I can confirm this, I'll go ahead and mark this 
> regression as invalid and file an issue with LXC. Thanks for your help 
> and patience.

Yes, it does appear that was the problem.  The attach POC patch against 
LXC fixes the hang.  The kernel is working as intended.

#regzbot invalid:  userspace programming error

-- 
Regards,

Daniel Harding
--------------Yb4lpw6XJqcdFybbm0AXJO0G
Content-Type: text/x-patch; charset=UTF-8; name="lxc.patch"
Content-Disposition: attachment; filename="lxc.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3NyYy9seGMvdGVybWluYWwuYyBiL3NyYy9seGMvdGVybWluYWwuYwpp
bmRleCBjNWJmOGNkZmUuLjVlZWU1MDYyNSAxMDA2NDQKLS0tIGEvc3JjL2x4Yy90ZXJtaW5h
bC5jCisrKyBiL3NyYy9seGMvdGVybWluYWwuYwpAQCAtMzM0LDcgKzMzNCwxMCBAQCBzdGF0
aWMgaW50IGx4Y190ZXJtaW5hbF9wdHhfaW8oc3RydWN0IGx4Y190ZXJtaW5hbCAqdGVybWlu
YWwpCiAKIAl3ID0gciA9IGx4Y19yZWFkX25vaW50cih0ZXJtaW5hbC0+cHR4LCBidWYsIHNp
emVvZihidWYpKTsKIAlpZiAociA8PSAwKQotCQlyZXR1cm4gLTE7CisJCWlmIChlcnJubyA9
PSBFV09VTERCTE9DSykKKwkJCXJldHVybiAwOworCQllbHNlCisJCQlyZXR1cm4gLTE7CiAK
IAl3X3JidWYgPSB3X2xvZyA9IDA7CiAJLyogd3JpdGUgdG8gcGVlciBmaXJzdCAqLwpAQCAt
NDQ0LDEzICs0NDcsMjEgQEAgc3RhdGljIGludCBseGNfdGVybWluYWxfbWFpbmxvb3BfYWRk
X3BlZXIoc3RydWN0IGx4Y190ZXJtaW5hbCAqdGVybWluYWwpCiBpbnQgbHhjX3Rlcm1pbmFs
X21haW5sb29wX2FkZChzdHJ1Y3QgbHhjX2FzeW5jX2Rlc2NyICpkZXNjciwKIAkJCSAgICAg
IHN0cnVjdCBseGNfdGVybWluYWwgKnRlcm1pbmFsKQogewotCWludCByZXQ7CisJaW50IGZs
YWdzLCByZXQ7CiAKIAlpZiAodGVybWluYWwtPnB0eCA8IDApIHsKIAkJSU5GTygiVGVybWlu
YWwgaXMgbm90IGluaXRpYWxpemVkIik7CiAJCXJldHVybiAwOwogCX0KIAorCWZsYWdzID0g
ZmNudGwodGVybWluYWwtPnB0eCwgRl9HRVRGTCk7CisJZmxhZ3MgfD0gT19OT05CTE9DSzsK
KwlyZXQgPSBmY250bCh0ZXJtaW5hbC0+cHR4LCBGX1NFVEZMLCBmbGFncyk7CisJaWYgKHJl
dCA8IDApIHsKKwkJRVJST1IoIkZhaWxlZCB0byBzZXQgT19OT05CTE9DSyBmb3IgdGVybWlu
YWwgcHR4IGZkICVkIiwgdGVybWluYWwtPnB0eCk7CisJCXJldHVybiAtMTsKKwl9CisKIAly
ZXQgPSBseGNfbWFpbmxvb3BfYWRkX2hhbmRsZXIoZGVzY3IsIHRlcm1pbmFsLT5wdHgsCiAJ
CQkJICAgICAgIGx4Y190ZXJtaW5hbF9wdHhfaW9faGFuZGxlciwKIAkJCQkgICAgICAgZGVm
YXVsdF9jbGVhbnVwX2hhbmRsZXIsCg==

--------------Yb4lpw6XJqcdFybbm0AXJO0G--
