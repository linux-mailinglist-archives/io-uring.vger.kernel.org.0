Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0496175E440
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjGWS7G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 14:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGWS7F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 14:59:05 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEA6137;
        Sun, 23 Jul 2023 11:59:00 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 44F9532001E9;
        Sun, 23 Jul 2023 14:58:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 23 Jul 2023 14:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1690138738; x=1690225138; bh=v5Kv5iz6fuLn+7shirlgVBNk4b6Xzv54sN8
        LYTm3QUI=; b=hdppA/XbeUlbJmhfEEt+klLUDZYAW7a6SMeFLHzCJA0+na+MX2X
        5YaMbvcvg41rD1AqWF391uGqpeNPy2BpMEGQOJI+UEldm9Xjx80HAECsDXAFkk/h
        Ge/TnMMiOGDXbSjTQ9vy9BQ+7DyOhZWtmp2lmLjRzKplt8R9W3j09eNcg0x5Y+Ej
        d5fxmlAY+o12uOcf/TJz2Tt6zq8Kis8ahRljekAcqWUrOzYNhaeSUJCP6po0cUta
        6/+xgJhCrWjgY5qPRTe+/6bECswzsBpHbilMO3sEvCj1M2RWDMP99mVqzCTerQHC
        hCFkU3JscQLb7i6Px92RQtTkryUKk+a6dMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1690138738; x=1690225138; bh=v5Kv5iz6fuLn+7shirlgVBNk4b6Xzv54sN8
        LYTm3QUI=; b=GhuHjBMv38VCbnkiD0qspVB5ybpL50/lLlK1GIttj+kZPGTwQ85
        fzLGvp3rBYi5LcwXiHYoZE0FNP6hq3U2zqeT3Sqi92NbndHTZkCHcJTnrLeWYNPy
        2DPHm72lnfDJyBhiihFq6g9TcgoGkmOHJ7sQVAnbhRDa9i3cMrueSjwzmIMT4TZD
        j4GD0YT/emh2sFYrcXqQb0MMDGePDgJaA1nd8loBZ5zLZx72QZGe3CfxFijIcYj5
        /xyMTCagkMVc7kZhJk4n4YIi+XpHq3fV4FOAYLFH1QP0pL+m1g9syeeKjWfIWJT7
        XQuo83jBFMohjNF4x5YzsZhH3Xv/AiwI00A==
X-ME-Sender: <xms:cni9ZLAxwhLRyHbRJ4DpcOLAIukcCrWYU_9P73f20xv_lRz-CG2png>
    <xme:cni9ZBhkiSskXztF4HWgMFStYh-qAqTWB8VELwHEklJzwPI9c_2yEh4sgoQDFaI3Q
    qTRSGQxCvO-34xKAg>
X-ME-Received: <xmr:cni9ZGmG7QY215ZdQXRx4ANit0EzHEEu9BqhM_yWIxbX0F2qFPhWrZBwusoK1Xt8nIxl_zuhDB7cRbV1NUi-0_0LriZobppLVBrTd5oNhq4AWErTMxelp4fFiyHE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrheeigddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpefhieetgfelveettdffjeevudejkeejudfgtdevffejledvtdefkeeg
    gfejhffggeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:cni9ZNz8k5Xl7RAboeVV69sMN3I7MnRQVNRiUs7X3lhc8vDRuWhtVw>
    <xmx:cni9ZAQWRMS1MvQmxtRKCsqBwENVKbHHnQadQsokdvLTqu-iaPDBLA>
    <xmx:cni9ZAaUWwGL-Hjcq4zSUefcrTQgym1mNigfwVmx53V0rlF_Wk9Yiw>
    <xmx:cni9ZPFi33bvsWzNq3I4UMRFZyBnxBhGxJBE_JxjTk5UvGXDpLRQiw>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 23 Jul 2023 14:58:58 -0400 (EDT)
Date:   Sun, 23 Jul 2023 11:58:56 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Genes Lists <lists@sapience.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Message-ID: <20230723185856.h6vjipo4rguf6emt@awork3.anarazel.de>
References: <20230716194949.099592437@linuxfoundation.org>
 <538065ee-4130-6a00-dcc8-f69fbc7d7ba0@kernel.dk>
 <70e5349a-87af-a2ea-f871-95270f57c6e3@sapience.com>
 <2691683.mvXUDI8C0e@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2691683.mvXUDI8C0e@natalenko.name>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-07-23 20:06:19 +0200, Oleksandr Natalenko wrote:
> On neděle 23. července 2023 19:43:50 CEST Genes Lists wrote:
> > On 7/23/23 11:31, Jens Axboe wrote:
> > ...
> > > Just read the first one, but this is very much expected. It's now just
> > > correctly reflecting that one thread is waiting on IO. IO wait being
> > > 100% doesn't mean that one core is running 100% of the time, it just
> > > means it's WAITING on IO 100% of the time.
> > >
> >
> > Seems reasonable thank you.
> >
> > Question - do you expect the iowait to stay high for a freshly created
> > mariadb doing nothing (as far as I can tell anyway) until process
> > exited? Or Would you think it would drop in this case prior to the
> > process exiting.
> >
> > For example I tried the following - is the output what you expect?
> >
> > Create a fresh mariab with no databases - monitor the core showing the
> > iowaits with:
> >
> >     mpstat -P ALL 2 100
> >
> > # rm -f /var/lib/mysql/*
> > # mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
> >
> > # systemctl start mariadb      (iowaits -> 100%)
> >
> >
> > # iotop -bo |grep maria        (shows no output, iowait stays 100%)
> >
> > (this persists until mariadb process exits)
> >
> >
> > # systemctl stop mariadb       (iowait drops to 0%)
>
> This is a visible userspace behaviour change with no changes in the
> userspace itself, so we cannot just ignore it. If for some reason this is
> how it should be now, how do we explain it to MariaDB devs to get this
> fixed?

Just to confirm I understand: Your concern is how it looks in mpstat, not
performance or anything like that?

As far as I can tell, mariadb submits a bunch of IOs, which all have
completed:
...
        mariadbd  438034 [000] 67593.094595:       io_uring:io_uring_submit_req: ring 0xffff8887878ac800, req 0xffff888929df2400, user_data 0x55d5eaf29488, opcode READV, flags 0x0, sq_thread 0
        mariadbd  438034 [000] 67593.094604:       io_uring:io_uring_submit_req: ring 0xffff8887878ac800, req 0xffff888929df2500, user_data 0x55d5eaf29520, opcode READV, flags 0x0, sq_thread 0
        mariadbd  438034 [000] 67593.094690:         io_uring:io_uring_complete: ring 0xffff8887878ac800, req 0xffff888929df2400, user_data 0x55d5eaf29488, result 16384, cflags 0x0 extra1 0 extra2 0 
        mariadbd  438034 [000] 67593.094699:         io_uring:io_uring_complete: ring 0xffff8887878ac800, req 0xffff888929df2500, user_data 0x55d5eaf29520, result 16384, cflags 0x0 extra1 0 extra2 0 

Then waits for io_uring events:
        mariadbd  438032 [003] 67593.095282:      io_uring:io_uring_cqring_wait: ring 0xffff8887878ac800, min_events 1

There won't be any completions without further IO being submitted.

io_uring could have logic to somehow report a different state in such a case
(where there'll not be any completions before new IOs being submitted), but
that'd likely not be free.

Greetings,

Andres Freund
