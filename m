Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A1E79F23D
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 21:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjIMTkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 15:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjIMTj7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 15:39:59 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3451999
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 12:39:55 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-34f5357cca7so250105ab.1
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 12:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694633995; x=1695238795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tft1HooN87hi/19RuephXAGarkXU4BD94o5nCoYckJ8=;
        b=pNQ0oV1Wwn3LRIFz/Kn8b8xec3OuZPtPpz/wzOcOfDndpvgi6/oE8Y8qDS1W23RBl/
         gsjsyUxgzV9SIXxLsBhEz80kFbNmjjpntZ2K+hIlCRuuIDc00ARCHjsP2qjsFFYtU+8d
         adccqSp4pwsT+Mz+rfrjOUbXf5MZkx2ttYieZyLeznSDIVl7vxk/UVTDRNWzfEImsJa2
         PYLUNpD6cKeZ9HGUhFlqIKpCKka8NMUE/rvZWMq+HUQfLMg3SlO+OdX865sPO7923rkw
         ZPICN4yBO6BpIhqGWUztAfkHMugorYZALESivKg4DLoAmMinwMhcfYZGwuIXziPys7SH
         SleQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694633995; x=1695238795;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tft1HooN87hi/19RuephXAGarkXU4BD94o5nCoYckJ8=;
        b=O8h9N0IOW4js2MPz45tSwlBZ0ThyDMdMlNqENWw/UW1X2+nMhmfqu3hOF8rHxNFqu2
         GsmsWZkSX7ZngL9dgF3HZtgCNPJhMQC6F04S6N53wkGLDhyffM62X+iU2agaYNG+fePU
         qNu+LScfDbUPE3cQ16lHEMgD5UOAd46MwB0EIebP/OOAKZtw1yf6k552QfGQkimoP+Y6
         +DEB1GL3Z6/xBBgnZmaLVaA1oomEmpfvWts3LEo1OyjKJJy0TDGqRE6OXciTQBdx2mQb
         RUGHyshH0nyKHEnu8mX941OekFyywrox8SjHNbEHQWwBeUTSgchOOoyuRHK5A56Tf/4X
         EIUg==
X-Gm-Message-State: AOJu0YwY/Ynwz/gIr51Qc3RKoBf9w/uP6vwCxXGok+hFzLGkxiS5Mg5q
        VSykZmQvIMOKfcYG1fjcDoGpSw==
X-Google-Smtp-Source: AGHT+IGtBzcobfCWCkQ5HPj4+SqKK9ECxFRGlGCGQqDAtr3vPCIrAPClhL0Dsulx18cZsBLQCEwl2g==
X-Received: by 2002:a92:d986:0:b0:349:4e1f:e9a0 with SMTP id r6-20020a92d986000000b003494e1fe9a0mr3254955iln.2.1694633994913;
        Wed, 13 Sep 2023 12:39:54 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d4-20020a056e02214400b0034ac1a32fd9sm2500863ilv.44.2023.09.13.12.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 12:39:54 -0700 (PDT)
Message-ID: <efe602f1-8e72-466c-b796-0083fd1c6d82@kernel.dk>
Date:   Wed, 13 Sep 2023 13:39:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/8] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, sdf@google.com,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org, pabeni@redhat.com, martin.lau@linux.dev,
        krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
References: <20230913152744.2333228-1-leitao@debian.org>
 <20230913152744.2333228-8-leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230913152744.2333228-8-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/23 9:27 AM, Breno Leitao wrote:
> Add support for SOCKET_URING_OP_SETSOCKOPT. This new command is similar
> to setsockopt(2). This implementation leverages the function
> do_sock_setsockopt(), which is shared with the setsockopt() system call
> path.
> 
> Important to say that userspace needs to keep the pointer's memory alive
> until the operation is completed. I.e, the memory could not be
> deallocated before the CQE is returned to userspace.

This is different than other commands that write data. Since
IORING_FEAT_SUBMIT_STABLE was introduced, any command that writes data
should ensure that this data is stable. Eg it follows the life time of
the SQE, and doesn't need to be available until a CQE has been posted
for it. This is _generally_ true, even if we do have a few exceptions.

The problem is that then you cannot use user pointers, obviously, you'd
need to be able to pass in the value directly to do_sock_setsockopt()...

-- 
Jens Axboe

