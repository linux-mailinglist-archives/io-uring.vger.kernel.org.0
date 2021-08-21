Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C733F3CB4
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 01:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhHUXO1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 19:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhHUXO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 19:14:26 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64375C061757
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 16:13:46 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id v16so13328572ilo.10
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 16:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z1dd7qB2dn2ZlP15fr9/XnHG7J/ipuohJDgOwA4dvfE=;
        b=cBgsPFy08HLg97aYXrYkozG0I5vo9drn2oiSnFRmKFkcRmQ5RN0h4XEhFpIp/e8OA+
         iuPhHEModNiSa4fy8S/RdkqiS9X0RwuuFuy8+f0vWVO7q+0qZjHDZ/qER3QsDDITCQJB
         yr/leLbkuO7jrJjKrOQxSwnh5lXAgWCj4Y7e1IzEk+xQHuj/ULdhA+S7s1LXB+EIX4/3
         QK99uvI6K5Ysl8mdDz/tc3EdRkSYydAiThxz2BvUbIfgt1wUfnahm1wUD0Z7XuZkDQ+f
         1B+y5hCC/J0nAmbncW349iPPWTxqh/xbwWCp2YprZW9pTTh+bu79n0nLLoJFCg8VT4gF
         lHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z1dd7qB2dn2ZlP15fr9/XnHG7J/ipuohJDgOwA4dvfE=;
        b=NmGy1pOnDFAMvpkEDoxPa/Cyav2PN6IcYeWxF9EsCVgpaGi0dlqDwGNb8OvB9qp5ix
         GH7PCdy5Am0IXAqqFGsS2hjogUCdmvDqnM9TG7vqEhxUrEzAlcVdlZkBpvJXiERbnay/
         +wetlyqiZHDapAAkw/IT9NOQ3kpf51bRzrA6+k9hwmbF8kKCzQvSgaFEXVTFRmorJoLo
         +Gjp4M5Ufg2ZGVqGCbLi5yY72gqkmyDer2MSKAzCYxwNWDpMj4dLg1QXyxIf5Vf27zPz
         orrzvJB/wVHr0yn65oWrUE0n+fOoV3t/LX9SmGeSXz/cYIcIBoOWZ0vW/js7b6REfAnE
         WC6A==
X-Gm-Message-State: AOAM531TlB2lQ5I3ZH2D+0Cm5bastPqJtbpspbCCEnZFyWnPsqRUep4G
        Kum+cuSSgVYiYfVJ1chmncxWQg==
X-Google-Smtp-Source: ABdhPJwuZcs5+9WXBEWkP5hvXAt6zeEg+8AY7vGi1nuZt++LvhGEAW3JmwvXNE4INJH5NlWRHEdSXA==
X-Received: by 2002:a05:6e02:13e1:: with SMTP id w1mr19413927ilj.116.1629587625695;
        Sat, 21 Aug 2021 16:13:45 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c4sm882045ioo.2.2021.08.21.16.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 16:13:45 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] iter revert problems
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
References: <cover.1628780390.git.asml.silence@gmail.com>
 <3eaf5365-586d-700b-0277-e0889bfeb05d@gmail.com>
 <YSF9UFyLGZQeKbLt@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <120e5aac-e056-1158-505b-fda41f1c99a5@kernel.dk>
Date:   Sat, 21 Aug 2021 17:13:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YSF9UFyLGZQeKbLt@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/21 4:25 PM, Al Viro wrote:
> On Sat, Aug 21, 2021 at 03:24:28PM +0100, Pavel Begunkov wrote:
>> On 8/12/21 9:40 PM, Pavel Begunkov wrote:
>>> For the bug description see 2/2. As mentioned there the current problems
>>> is because of generic_write_checks(), but there was also a similar case
>>> fixed in 5.12, which should have been triggerable by normal
>>> write(2)/read(2) and others.
>>>
>>> It may be better to enforce reexpands as a long term solution, but for
>>> now this patchset is quickier and easier to backport.
>>
>> We need to do something with this, hopefully soon.
> 
> I still don't like that approach ;-/  If anything, I would rather do
> something like this, and to hell with one extra word on stack in
> several functions; at least that way the semantics is easy to describe.

Pavel suggested this very approach initially as well when we discussed
it, and if you're fine with the extra size_t, it is by far the best way
to get this done and not have a wonky/fragile API.

-- 
Jens Axboe

