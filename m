Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7E3B238D
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 00:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWW0X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 18:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWW0X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 18:26:23 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74077C061756
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 15:24:04 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r12so5430199ioa.7
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 15:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0l0wLNR77GMohwjNSfFqVBgcOwDqqJnWYBylz7PW6SQ=;
        b=ZQv2q8CHfpxTd+1bctfkF5Og6+VlNNcZTpi2VJefL0TsTwN/I26TnK24eTRAZ5XmlT
         KD1byGLkKBqLsNPcJdKlPnpISMiDNDUqFMVpLRRDb4ctE7oXKuRBydG/Y8tOPTCm308U
         NP+97iKmn3SK7YAHQyH7nV3rXj7f7k+o3RQ6SCX7cGyRyzEYg1xTvRujf2AJXHCv7s8S
         IGz76ZZiNPIbVi+6jlK3oMtY71mrkpU7FpVq/NLkJtzTBtgwz7QRacVr+ZWMmGGVCCS2
         gKpAYCXUvAj7gFOl+NcetYvmd7FtCgmmICq+T+QNc8bsMsfN6zo3keNnkd72hdBiYvqy
         8qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0l0wLNR77GMohwjNSfFqVBgcOwDqqJnWYBylz7PW6SQ=;
        b=aiSDz9I4KS/xGmF40vldMP3xl8YsRcGzYruSb40yd/krRd0spPy+/pjwy+PqObojue
         ta4UhXqAYeJhO3kSJzu2fnr7YLdVCSKgoXT0bq6Ue+Kcq5UvfEddTflBS2Katm+gjz2b
         Oz8xo8RdpYWf4V4xg18ayPxVmmotl1ccf4GXoKMGu2k7ejijCHDsUwsQJj1SkAp8JBHi
         eZ99LYwNXb/KKh23IQOPC3ZnGTfU0CV0hwZTasAgJKhIP0yukLSVcY88pygoiQ5NMA4D
         UvBpWZEOFLKhtvgoOCbJIP98zCbRgu9thLIDE2FAiVwwgdjtLHo1AQNLUzdJ1T4+xfQC
         RNsQ==
X-Gm-Message-State: AOAM532QSDvhNgbbdoCERnW+iQ+YUuI0MvUYc5hKpqu56Nmmg28+w54h
        RpnIWYXW/2cbBcLuwlH8zele0w==
X-Google-Smtp-Source: ABdhPJxBCaRjTIje5xEeMYTOnDdq8f5SGVbPe70CDXRRzqaAiWHyjXViY6nq9TPIAAcPt/yx0R/DhQ==
X-Received: by 2002:a5d:83c4:: with SMTP id u4mr1473648ior.21.1624487043319;
        Wed, 23 Jun 2021 15:24:03 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id e4sm157435iov.33.2021.06.23.15.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 15:24:02 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] io_uring: Create define to modify a SQPOLL
 parameter
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1624473200.git.olivier@trillion01.com>
 <b401640063e77ad3e9f921e09c9b3ac10a8bb923.1624473200.git.olivier@trillion01.com>
 <b8b77ef8-6908-6446-5245-5dbd8fa7cfd7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6a566122-c4b2-6594-cc94-c578988d3f80@kernel.dk>
Date:   Wed, 23 Jun 2021 16:24:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b8b77ef8-6908-6446-5245-5dbd8fa7cfd7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 4:14 PM, Pavel Begunkov wrote:
> On 6/23/21 7:50 PM, Olivier Langlois wrote:
>> The magic number used to cap the number of entries extracted from an
>> io_uring instance SQ before moving to the other instances is an
>> interesting parameter to experiment with.
>>
>> A define has been created to make it easy to change its value from a
>> single location.
> 
> It's better to send fixes separately from other improvements,
> because the process a bit different for them, go into different
> branches and so on.

It's not a huge problem even if they go to different branches,
for these I'd be more comfortable doing 5.14 anyway and that
makes it even less of a concern.

-- 
Jens Axboe

