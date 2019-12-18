Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1EF124E75
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 17:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfLRQ4x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 11:56:53 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44217 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfLRQ4x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 11:56:53 -0500
Received: by mail-io1-f67.google.com with SMTP id b10so2678535iof.11
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 08:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rTEAWvowPGiFm5bG98LTp8ro86bKvhqp1ci3ULDNOxE=;
        b=Cw3/cX10PPDAUYUM5rAGyGOME6Qu+RzUqAQmtd25Lg/C2gnl1JKPerg/GIHijZIZt9
         XhVJDbh2y/2QKLauB6fy2cvWemLqWd9Gq+64D27LSHQYbz/b7QMsQIeYkfYl8IubuZk9
         a2MaJhq1ioT8tZ7vxwy9ulLODP/ASjy0CZSXVW2jZSFR1Tov9j8Rcez5kHAi3VnQJZwQ
         wOR1hvatDhTd4Wdoj6B241fKvUaoghBKN8S3fK8cO+sVjk6sgl503k/8I0AZqPCPLTRg
         r3l9SeeB3eybTXsugdhUtMF11A9i59bZFyDvqpK/VIthYXb3OtSb5unN9+g2zlbDKBEs
         1TWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rTEAWvowPGiFm5bG98LTp8ro86bKvhqp1ci3ULDNOxE=;
        b=Bxo2g+3uDy5NlJiLcBTeK/9/RYDJidFbRIiwcmSs5q/gep/o413v2y0jqsrJ7L+J66
         j1YcYVmfIlmIkm9PrIvUNsn6JIObTzY6oaFvJIjeF2JXMMaaUIn9ryFibLbyVStFWraQ
         6m5FslBRfhLtvyhQds2TeQ+3iD8U4RuJD6IkQq6PLv1KzJUe6loKUCv4PVrnVGLJ3afx
         VEdsqp6AbSKMuroihENZboL7IlTqgzpDh0xu+kjtheEjHctZQ0nTmf/FcKy+Jd3LpEDs
         Oi4U//EUejlqCUtbVPLHmNwxMYyeaF2oaXUDUG1Q1jdUXI7TViXRbcjIuNuK9v0x3bB2
         dX0w==
X-Gm-Message-State: APjAAAWrGab9woelgq/GQHyjYusPho7SNpFxusG2bZ2SYwPddo6W4rWD
        eX2FYwzOKN3P+eOEcabxoa2JWQ==
X-Google-Smtp-Source: APXvYqw6HgfbjWrkvdzzoP8foDMwN38PPf5JRmq4JvAUC33lN7IwtCTqA7XbBuU8q9KC3+R9uWtO9Q==
X-Received: by 2002:a05:6638:97c:: with SMTP id o28mr3342377jaj.8.1576688212169;
        Wed, 18 Dec 2019 08:56:52 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm836936ili.50.2019.12.18.08.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 08:56:51 -0800 (PST)
Subject: Re: [PATCH v5] io_uring: don't wait when under-submitting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576687827.git.asml.silence@gmail.com>
 <28aad565ed6c3a3a03975377aa62035b1b0a4d97.1576687827.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7b684479-d0f9-4e74-b947-5ceba577734a@kernel.dk>
Date:   Wed, 18 Dec 2019 09:56:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <28aad565ed6c3a3a03975377aa62035b1b0a4d97.1576687827.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/19 9:53 AM, Pavel Begunkov wrote:
> There is no reliable way to submit and wait in a single syscall, as
> io_submit_sqes() may under-consume sqes (in case of an early error).
> Then it will wait for not-yet-submitted requests, deadlocking the user
> in most cases.
> 
> Don't wait/poll if can't submit all sqes

This looks great, thanks, applied.

-- 
Jens Axboe

