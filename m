Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD5E47E9B4
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 00:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245126AbhLWXts (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 18:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbhLWXts (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 18:49:48 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A826C061401
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:49:48 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id x6so8945542iol.13
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mm+37+LGUWpMzI/BnAHKS58Iy/RULBh33GpfIX+ixPQ=;
        b=zSh2vrwzDEOQoWXwrN5gP+D3q95zpijGN9GjW1oTHBJrSJ+nNm9W3sRe5w2iH9SPo/
         dlWZ76+X8kg2tCiPJJSfQ3lIzIf6ZNR06m7ssjjaIZKFlAW2HLq8XJl09grtXJ0Lmede
         7C203ejQzLo9CVyn8OqxqI7VG1TW/88/C+FpyWWCTF9f0EBAQXdiZUE+IgOG28xsS3eN
         ewz5H9hVdZoz7fl5eCeA6eHWHAMAepWr4qp4E5Lohbo0fNzSHKjaE7ArQuxuA8HEDtQN
         YlA/CO4/BxNbuH8GqHfjHIMWvPtEnmhKxsDrUbRhO+iLK3d7jEU+sANZu1r0b+SF3YEv
         mFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mm+37+LGUWpMzI/BnAHKS58Iy/RULBh33GpfIX+ixPQ=;
        b=mE2Ofv4TssIXUj53orea0SHP2bJ71/9kffuCr3YrzH9Sb/OnrU81jdjsdx9igS3l31
         2aUw/nwhlz/Gxg7LFRcfLe3a6DuGdtgCYcO2GJ5Y3ZXFZmilVQ6aDwN2aOhL/uUdw+JL
         8qn8qy4pMtTC1358XaRUMrjxy0tyvwDwXEP+n0ElIIUz9JAwajU1Ji8qvujltOMHByQ7
         T6NB3QAYtnZ40+1gY8MYVuXGpg1E0dmwsSUcCnQBYCHFQ3maXW/UrUsRNr1HsnvFXb3T
         q+Y3zOrGypw3SzI6PA4ajcOBjpMhkHm2l6gFIRLlrFPxknuNqr24o+nJKREQ9g4JXzEO
         JwrQ==
X-Gm-Message-State: AOAM532mvTu6a8HYJwI1kJ9g6CZGrte+1slG4oFKyILt/4hUTc61c5bw
        ubxiHzAAH2n9OM2Qrq7INMcG6ns/F42zZg==
X-Google-Smtp-Source: ABdhPJym6rYV535R+p0qecVqci7NWlppHas1xZ6naAPZBH86eLIF8P7B3DXRmjL1gxk6xP1dmx4rCg==
X-Received: by 2002:a05:6602:14ce:: with SMTP id b14mr2183836iow.143.1640303387223;
        Thu, 23 Dec 2021 15:49:47 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id x15sm4008998ilv.22.2021.12.23.15.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 15:49:46 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
 <CAHk-=wj-fA6Sp+dNaSkadCg0sgB2fKW7Wi=f8DoG+GmiM2_shA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e91fe63-512c-f8ce-066d-8d11d3d70daf@kernel.dk>
Date:   Thu, 23 Dec 2021 16:49:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj-fA6Sp+dNaSkadCg0sgB2fKW7Wi=f8DoG+GmiM2_shA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/23/21 4:39 PM, Linus Torvalds wrote:
> On Thu, Dec 23, 2021 at 1:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Single fix for not clearing kiocb->ki_pos back to 0 for a stream,
>> destined for stable as well.
> 
> I don't think any of this is right.
> 
> You can't use f_pos without using fdget_pos() to actually get the lock
> to it.
> 
> Which you don't do in io_uring.

Well, current position doesn't really make much sense to begin with in
an async API, but there are various use cases that want to use it for
sync IO. We do have the file at that point, but it's most certainly not
sychronized across completions (or serialized with other fdget_pos()
users).

We could hold ->f_pos_lock over the duration of the IO however, that
would probably be saner... As completions are always done from the task
itself as well, that should work. I'll take a look at that for 5.17.

-- 
Jens Axboe

