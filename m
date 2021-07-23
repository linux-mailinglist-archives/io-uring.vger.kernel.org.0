Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC8B3D3EE9
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 19:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhGWQ4A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 12:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGWQz7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 12:55:59 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE55C061575
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:36:33 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id m13so3460840iol.7
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dUwxjEO6jp47Rz2JEQjvKi+qFhqfV3bJEfO0Rigrqe8=;
        b=m5lXE98mJ1kVuFljZ9hFbkn1S7yLGd0kvhu3A6dZPL0Pcl0m2AKWx4mBQ9fLP91c5l
         94MMjSaJ21QKUw7chZSIQDwbyr9RefYJHqXZ6eJ9WTHhX/Y8xMfCnNiZHe8rMdk1TA8A
         yBItfOpZTF0zfaxGEMOSgUGeZNbtfSUs89M8hQmUvnY635zPfc0tz7FZGbIMDinlcZaV
         F2gubBMSLcjXin5f4gyFpvvpabihpBOZx96lhqmCp/mHsC6dQkaDRGnnKPDZf61/dowN
         QfjXB2j4kdE2wlvwHTzNUJUInJEX1ChXNa5lvnwk7n8XRs4uXVbvmguK5ImrHgMnjdXK
         AyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dUwxjEO6jp47Rz2JEQjvKi+qFhqfV3bJEfO0Rigrqe8=;
        b=ZvDOcM8ulBfXfgRkkNf571Bu6yxXRQJnIN+z+gNZuoasULCqujBvsQHK+vWNKVurGH
         UeJNlky/aTMJ0DuWFlGXRwz4mz28C76b/LmKVL56s9ZdV9yqTbbhtVaY+aOYc6smVa9X
         rs0e4IzyoWyKd8UPfm/s4sDeEtEoqtZAdmngl/kiNY3rhDOKaSKE+5bHepDFt4QdwQsG
         G+uSDxqRCRk7Z4+xYmw732wJg0XCFkFWby2B7SUrxSFYSM+697Pmisdg21rYBntcbx5Z
         3voSwPGY5uIeyb2vU0cLCc8xv4YsiMgaociD//7g5MmPzEhWKvMMQ3pgntwzi3FOL4g7
         GRhg==
X-Gm-Message-State: AOAM532ncXhha5h9DStsgw68/3rCOKzKrPhOVDHhJINdTsdEkkHlWYh9
        pVvB2b2tB5qVidd/LToo3jY+8w==
X-Google-Smtp-Source: ABdhPJz92FO6x1+kfUTpbgotTdFxhjXK67vWFylh+q1fNBgGNRgJf0U1hFfjbcZTNBizIxjzcAQvkg==
X-Received: by 2002:a05:6638:2111:: with SMTP id n17mr4993668jaj.76.1627061792384;
        Fri, 23 Jul 2021 10:36:32 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x11sm3681181ilu.3.2021.07.23.10.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 10:36:32 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
From:   Jens Axboe <axboe@kernel.dk>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
 <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
 <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
 <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
Message-ID: <591b4a1e-606a-898c-7470-b5a1be621047@kernel.dk>
Date:   Fri, 23 Jul 2021 11:36:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/21 11:32 AM, Jens Axboe wrote:
> Outside of that, we're not submitting off release, only killing anything
> pending. The only odd case there is iopoll, but that doesn't resubmit
> here.

OK perhaps I'm wrong on this one - if we have a pending iopoll request,
and we run into the rare case of needing resubmit, we are doing that off
the release path and that should not happen. Hence it could potentially
happen for iosched and/or low queue depth devices, if you are using a
ring for pure polling. I'll patch that up.

-- 
Jens Axboe

