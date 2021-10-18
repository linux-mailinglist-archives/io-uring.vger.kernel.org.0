Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801944326D1
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 20:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhJRStc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 14:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRStb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 14:49:31 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2F7C06161C
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 11:47:19 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id e144so17494744iof.3
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ob0CbEwoPeJgo71AK4uZuz6MhzSfIwRl4kQrmn5LdSo=;
        b=zryvc2+iyGSLlKZd0t8mtv3dtK+YkZ6kCiMIVzLmOCw+zbbFJuxFfHrZQGVVW8Z/TW
         PV1pHcYGTrVezQlMjoAuu5kGNyrqdiYuG/GeRZcOJTVjmuCFTd6nNOeJroIWjkxAw5cs
         tz3ifwG1gL2vBK74CnzmmDPB4yueweSeWo9UNlJNnpz0HAlsCTrHwqRRIqSdzkDwYI2X
         dBVRhP7O8PO8oMRWc9iQnX913JrKtZwwuKwqFQyddPQMwlU+5371NAluDd5GA5c9mMit
         ELtH/Ijx4V4Azrr5hn/GmkqDn57YDAR7YTtu26N4uebU98kq9NzMdobGrWTUhNqKsKTg
         CpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ob0CbEwoPeJgo71AK4uZuz6MhzSfIwRl4kQrmn5LdSo=;
        b=eoBXOkolKqzfuLva49Les+tWD2fPCImCT79FRnYGjq6+aX+tD8uMyGNRVQWMYKjXPn
         BySPVLixW3VufQKAmFO3WNP88NHR/ulZay4EKlrNPZ0lwItNKx5/XQNOS7W+nB/d36nJ
         clRHbPMPFXJVvVdcT7RNf105hZO4cK+Ek3+iizixwMHwvH3COpOR/s5PBeG5Q5HbFYdE
         X92KTUZtDdWKYYfyn/kVwl/caVv3xFnsUwv+2H0+8DUAhoD3CiclYaTX3sIrOC2dwy2H
         UFdfsnZjsJXyrLYJzeld9Xg3JDxNUheaeLVKwbAHQwxewP+zs2qMKLd9GVd13uKYNO0g
         f1HA==
X-Gm-Message-State: AOAM531t5GcAtkKFhUBUjz7ui55VutCEaBDRoCDaZGHW8QPoM94uQTvo
        oaiT5VG+uCtfP8XZflle6fIc65sF5aGWfg==
X-Google-Smtp-Source: ABdhPJyDN2zfYxfknFmpN3T8LloR/QDQg7yngT5RHbjCQ8mEx+QxOBZHcTf3jfGc6fH5qUxmVu8Leg==
X-Received: by 2002:a02:cd9c:: with SMTP id l28mr1041464jap.78.1634582839074;
        Mon, 18 Oct 2021 11:47:19 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y6sm6832160iol.11.2021.10.18.11.47.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:47:18 -0700 (PDT)
Subject: Re: [PATCH] [linux-5.10.y] io_uring: fix splice_fd_in checks backport
 typo
To:     Kamal Mostafa <kamal@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211018171808.18383-1-kamal@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <056adbd3-62eb-4aca-113e-f80c27c94a3b@kernel.dk>
Date:   Mon, 18 Oct 2021 12:47:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211018171808.18383-1-kamal@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/21 11:18 AM, Kamal Mostafa wrote:
> The linux-5.10.y backport of commit "io_uring: add ->splice_fd_in checks"
> includes a typo: "|" where "||" should be. (The original upstream commit
> is fine.)

Oops indeed! Greg, can you queue this one up?

-- 
Jens Axboe

