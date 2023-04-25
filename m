Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 045E16EDA22
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 04:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbjDYCIN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 22:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDYCIM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 22:08:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FD555AF
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 19:08:11 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-517f1d5645aso850828a12.0
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 19:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682388491; x=1684980491;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u9kL3B7kjHy8PPa66UlycMCN26v+M99khrJHRSitBGo=;
        b=i2egaMBG5Mi4SLNl4VAwes4cRmCHb+QTvKWObFPtc8UAHLWnGDEtBrLte0Har8dJ1K
         L9uF7h1SvhVM8ad+BC8QlJp6/aI2XJLqzREXYbdtFR5rPYO3TMyuE9pPlfxcaHDcYJyd
         GKwQHudf8vEt+jN3Ipb4bbPSf8lvL3AL8pkP1QnbYi7DX10yo5Qh/VuEHVVL3D5bUmcf
         vnvgp+FeFFmhi3rxr9gvcpUH9apfBD+1itmLsLhsL21Zv9h6va+liw6bsjJf9mgT2Q54
         GRDrQajYejfUGCNW1Q9Dq6AYYA2PBAMxgEj0agNQwv23v5K6MQQ7+1x5U0nniN/7xozU
         qGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682388491; x=1684980491;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u9kL3B7kjHy8PPa66UlycMCN26v+M99khrJHRSitBGo=;
        b=DixzR/VqXr7Y7qc/FU2Zg1ZpFznKVJXTk9tENIRWg/r46fZQSbN9/lgCC8ucjH55kC
         kd2z0CbbEdWw93dt6Jxp8O7YmhXMYkmKNaXETIthVdoiOYQeLhfL5k8yg/mHzZJoci/3
         778mIsz2e40BHjM8yis0nLdIPXHmywPkTouEiPJHtjf9QosO6OlSCEnjdcxjI8iTM+E8
         O4J3JsUU9kgX5rsVAlt71iuwCwHHpBsnVb+I+XymK6yFfq/a00qHY11yjPB45NRLnLKa
         7DuPgiUHZOuSxqDr4VI/qikE5hqFRTl/EdL+Gu954RidvkhKP72e3IFUg/X27c+4kXgO
         Qq0g==
X-Gm-Message-State: AC+VfDy9DOs7vCpdfGDtmLRVRNY8Ac/5vWaMURCdlFun8ptK4WkPZams
        /jFh9LsutVUBhxxTwf/iJkD45kBgMbtvTa3ILis=
X-Google-Smtp-Source: ACHHUZ70PS3KYLiVxgVirVzTp8XrvFRMY6hUjl0qUNQkPZsxdLa8e5bUne/EONNTQmvpNjVKZDfU4Q==
X-Received: by 2002:a17:903:1206:b0:1a9:71d3:2b60 with SMTP id l6-20020a170903120600b001a971d32b60mr1006027plh.0.1682388490829;
        Mon, 24 Apr 2023 19:08:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090abf8c00b00230b8431323sm6974277pjs.30.2023.04.24.19.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 19:08:10 -0700 (PDT)
Message-ID: <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
Date:   Mon, 24 Apr 2023 20:08:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/23 6:57?PM, Ming Lei wrote:
> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>> check in terms of whether or not we need to punt them if any of the
>>>> NO_OFFLOAD flags are set.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  io_uring/io_uring.c |  2 +-
>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>  io_uring/opdef.h    |  2 ++
>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index fee3e461e149..420cfd35ebc6 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>  		return -EBADF;
>>>>  
>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>
>>> I guess the check should be !def->always_iowq?
>>
>> How so? Nobody that takes pollable files should/is setting
>> ->always_iowq. If we can poll the file, we should not force inline
>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>> returns if nonblock == true.
> 
> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
> these OPs won't return -EAGAIN, then run in the current task context
> directly.

Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
it :-)

-- 
Jens Axboe

