Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E581729EB
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2020 22:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgB0VG7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Feb 2020 16:06:59 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39483 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgB0VG6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Feb 2020 16:06:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 181C322007;
        Thu, 27 Feb 2020 16:06:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 27 Feb 2020 16:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=A5NPuU34XQSov1fBK0TRE0xsC3A
        j/eAKJgGOyd2Z3ps=; b=LQScykUUfXDZau4xvZEXkb4EiW1Y+YnW1rMEUbs1+hA
        Zg8qil2w7/yF4CA3L+aSArUC/PBwhgjxsgCfGbmRyOkp85gH+YutfW3yM/kKPcPJ
        aZfpXPxEGEYAcLrevFEwJsjfDbKoxw/ZtvOknxi52s0Nxo7V5Plb7p+EoGutWTmc
        aTQEZAo/WWRP6fdl7uF5vzoouECJZwFd9KDKv5uLm4qlezkZWnVMqAMwKg0e2d0s
        zCSOhTTQ7BKR0B3Bn446as2Pkf/I07PgweH91tDoDSxh5eVdwt7BAucysrPD4wyK
        aQyeCO8vOypunO6gOqgJUXCPMCPvEpxo1VBHRka5Mhw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A5NPuU
        34XQSov1fBK0TRE0xsC3Aj/eAKJgGOyd2Z3ps=; b=kSBa+vgLIO1pgh1jZsPn4S
        t5hDalGcSK1/mDu6PgjIL23FOgF6pirw8Ty5XhZFOnztp7gLdN3M4KVZW55JeiPN
        R6giCp4P8H8cWp+PyY6TWMII3zucj/1Fa6TS16MJ8KqkEa7y7KczuRdEuSZ3Uy+J
        BzAjRr7h63MwDJSPzei/PfylU33dqoyzAB2ku/T16poumGHa2B1JeRwA1XqYpnvU
        AcwEfakuVjqOFdIeG/R/oMh5ebZ66tdNCaol+RmNyu4on5pgnOBhYoXS6vMQq1XX
        pc4sb1Bs06AeFq0JV5vJ4Gfy1IwCTIhElH8DAqjGuaxkwE1tIdCxDADkBKObYvcw
        ==
X-ME-Sender: <xms:cS9YXjurrtaBiL-2Tdk6cdDBH_12B_2INIICzgr4fx1NunXMRBQYFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucfkphepie
    ejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:cS9YXk6gO2ylDkEHZctLI2FjfXmsUG2Ad9waEEt3V-gwECCS0vpsOw>
    <xmx:cS9YXndRWNxt2YE-FZa1sBUErim_rSa0NC_4qQ3S39XS0aMmth_eig>
    <xmx:cS9YXpyAS-5m5uJz-iZmkxq1k1dSSBs5cZRZwGEA_DNaFgVk6ckKkw>
    <xmx:ci9YXutFYY4zgrIkgrpx2WjVA2nyyKmqYnt0GTSoAeYhCnS9r9TfYQ>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 36D63328006A;
        Thu, 27 Feb 2020 16:06:57 -0500 (EST)
Date:   Thu, 27 Feb 2020 13:06:55 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Deduplicate io_*_prep calls?
Message-ID: <20200227210655.fr3cqphj2ab4z36n@alap3.anarazel.de>
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <acb90f56-bb54-90e2-9c87-be4f754b322b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb90f56-bb54-90e2-9c87-be4f754b322b@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-25 12:26:34 +0300, Pavel Begunkov wrote:
> On 2/24/2020 6:50 PM, Pavel Begunkov wrote:
> It seems I have one. It can be done by using a const-attributed getter
> function. And I see nothing against it in gcc manuals.
> 
> __attribute__((const))
> static inline u8 io_get_opcode(struct io_kiocb *req)
> {
>     return req->opcode;
> }

That's practically safe, I'd assume, but I'm not sure it's theoretically
sound. The gcc manual says:

> Note that a function that has pointer arguments and examines the data
> pointed to must not be declared const if the pointed-to data might
> change between successive invocations of the function. In general, since
> a function cannot distinguish data that might change from data that
> cannot, const functions should never take pointer or, in C++, reference
> arguments. Likewise, a function that calls a non-const function usually
> must not be const itself.

and since req might be reused, this seems to violate the point about
reading pointers that could change. Which certainly isn't the case
here. Theoretically the compiler could e.g. understand that fallback_req
or such should never change it's opcode.

Greetings,

Andres Freund
