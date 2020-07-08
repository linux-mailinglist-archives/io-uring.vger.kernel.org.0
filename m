Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A891219249
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 23:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgGHVTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 17:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHVTT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 17:19:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD9BC061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 14:19:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f16so120950pjt.0
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 14:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=jrwYgAF6dJvXuG89/k7P/OJDUiiD7BekAwAZ9AjD50arRtxnE1xbe/1MpU1O0Lodfo
         /M/hrJZMrYQOUzuPeNYuEnbUToY225dveCdAfTZyqzPdSRsoW1QS2XR30KkOPuVJr9Yc
         VY0CR/gykanfPGLh8krT2ekfXGxaYo5FstDlWgxAMsaU0t+A1ZizMOi2OvT1rSxNiYiR
         N4XRPtcYcW19ZHRJlPawrUviUvbfQOYB8KRMYrWFR0hQPEfuZoYr0WxBxSCQFSh45gQ5
         Xuq4lwixERgdUBOvTnrfkkIwuic2XXpjip3rIqBjwDYQRFGwmhUjdvCPPm1wveBrXDu8
         TZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=iUfU26IS2aDFdnBVU8ut9YoJdBzrri2vCTNjFURXNmVKlTwbGd78V7apTDu3ADsoce
         OGsIOnXLFKYSl760p2SNQb7DlSRLwZJmk1gvnnpnmD5T/+TXJS/J4W2+Dl0qjwAKJwCe
         de8HtjQeLEIq2n9qCQtI7KVPoC5p3n39TqVokBeSbsIKlOJ7Jjui7fdk3V5BJfph8FVz
         WY74+oKp6kR2EpndJoifHn1q4RFXSdKcVwXkT8ji26DfCkGE5BFoKAoRzskiDAyCceek
         CHLwTzdqkwQxCsEMEMw2qXDcg1zHywAqdw6RnSehzP26xbVD13+j+hisKt08O0A9YX4X
         8MDw==
X-Gm-Message-State: AOAM533zJ4fHbCR5kwR6X/RGH5DZhxInPjF+LIJlAs1JFnngprIdb//C
        54rTs2zk/aFD0mBTIamsa29EUkNJlebw6Q==
X-Google-Smtp-Source: ABdhPJxFk6OzPfyfbBJ6Y7pA3+dQxrzhMXVcgKwa/YBiviVpwmnSF2gXlbj0pVd/y7uB6PmLl77NmQ==
X-Received: by 2002:a17:902:a389:: with SMTP id x9mr12670402pla.63.1594243158500;
        Wed, 08 Jul 2020 14:19:18 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i132sm683452pfe.9.2020.07.08.14.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 14:19:18 -0700 (PDT)
Subject: Re: [PATCH] .gitignore: add new test binaries
To:     Tobias Klauser <tklauser@distanz.ch>, io-uring@vger.kernel.org
References: <20200708211648.19189-1-tklauser@distanz.ch>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d8c25995-2af3-f461-58ff-153773be8d82@kernel.dk>
Date:   Wed, 8 Jul 2020 15:19:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708211648.19189-1-tklauser@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Applied, thanks.

-- 
Jens Axboe
