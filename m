Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A045304328
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 16:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391747AbhAZP4X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 10:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403916AbhAZP4K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 10:56:10 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449E3C061D73
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 07:55:30 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id g15so2459166pjd.2
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 07:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TLAXVDG3N04Es0tVCGgmdicEaIhkk2mJ8jgpPulLjw8=;
        b=aYPKqFr+Z2RJcTsClUHf6RQc5dH3tmOTj46dNQ9MamBAdgWbOF5idD9ApA08VlXDHd
         FFpb9ypINgyFYVBR+o0KouHes42BeRQmkSF+a7cpNdeWVgVruiq4pzxskDcmuInUQi43
         GYEaJH6kzV87OfHReUiILtew3n8aBDJrtYMC29QQwwS1gJP0hdac+j3NA8Fmul5D8Grp
         X23eqWsDZT6DDr8mNxDKcHEgItOVyKt+yqgxIX2sVWBT0wUbIfQVeT9evHIviMY77KxO
         Tp1p0jqj6iPtf5tBBGCn6unQeWFuliH4gQRdov3pS40O/t4/8w2t2p+29mgVgtGMe46C
         Wj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TLAXVDG3N04Es0tVCGgmdicEaIhkk2mJ8jgpPulLjw8=;
        b=FpMdSUeWc/3f8zOs27GUNS/G7iHxOY5DvDT5gPog9BhiN1xRRzSVz8FTaHmRvLgh3D
         Y6XNGAqmF8q1yCAipL7q3jiWLHXIJKpqD0QL9HcWXqoxmGUJK1jCgyBXBP+f5CoodSax
         5LZsoJNhwdl/Ab73woMk8D1yccuOWk+tVSCBMiPyZmt+mYM6fO70+GFqUzIeK0PEvL+m
         Pf+QdZfXF2tCYmR8Lp/g3EN42jKuKQIrxxSiEleB/n1xARQFjeuaBDBkwJXI+SOApSLM
         N8CW4b50uIn9pU7FK7uN3XgTO/+wUC3/3FKWmwpT8Zr7YNrq6tf8xBQPl/tcufVGsARF
         md4Q==
X-Gm-Message-State: AOAM5303w0s9EKuIwGDNe0hPgNZkYsFaWsF8hq+lE7+7wsJP9DgzSFyM
        zmUmBbxAI6l28S5r86J/mONNLdhcGH2WDA==
X-Google-Smtp-Source: ABdhPJwxlBJOdDi2qT3dcTueDykPOmBPStJhGHQMrDqFAET+diOZ6eFtBdS53ZjJldMXBp2hQu/lcA==
X-Received: by 2002:a17:90a:1c09:: with SMTP id s9mr426209pjs.83.1611676529616;
        Tue, 26 Jan 2021 07:55:29 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x186sm18685940pfd.57.2021.01.26.07.55.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 07:55:29 -0800 (PST)
Subject: Re: [PATCH v2 1/1] io_uring: cleanup files_update looping
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <5998587a14bb4deff29beae622ff5a59a5bbedc4.1611668970.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <474c6a0b-fdb6-447b-5e03-e1b3efec0369@kernel.dk>
Date:   Tue, 26 Jan 2021 08:55:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5998587a14bb4deff29beae622ff5a59a5bbedc4.1611668970.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/21 6:51 AM, Pavel Begunkov wrote:
> Replace a while with a simple for loop, that looks way more natural, and
> enables us to use "contiune" as indexes are no more updated by hand in
> the end of the loop.

Applied, thanks.

-- 
Jens Axboe

