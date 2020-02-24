Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48B516AAB8
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 17:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgBXQHd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 11:07:33 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41107 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgBXQHc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 11:07:32 -0500
Received: by mail-io1-f67.google.com with SMTP id m25so10770952ioo.8
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 08:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EXZUtcM+bpg2OqNBFvOQyUmIHzG4zJfkhe6zbJI1+XY=;
        b=aW45opTTIfDiXsjJa0MGcQraAV3eW6xvI9VWFAvuEgl4qaP+361Wb6RcKIvbmdrGg4
         n4LOo6FQaWRey98ReHkGXxtwAhsDdoM47sKOFFHbmRVHrt7oyOnIror8QD7SrVzMQfhv
         gJEgeMeKxFeUtGN+6mqueD4tSdL/TC8W6dif1UZq0kTXMnlNohtNfJHHBPyWUyHSR+Fa
         gkWOOx8kNareMLc8ov7w2KZJYxlUjoL9uN+ST3LyepD88ZwIYwYGDRz6R9u4I9paLcKq
         NchU0AxUd5XTB+bGZ9PDvIvouDuAWQLVa4P3dT0nVJPjxBDv74Rv5ABYihRHM1Fy5aBn
         nNKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EXZUtcM+bpg2OqNBFvOQyUmIHzG4zJfkhe6zbJI1+XY=;
        b=Jenolyorddgpk2cEHwSLtL5FIpjf7htMTwebcDjFkhgS8hNP2Oxpe+sXXExODK1GmJ
         /A5Wf7C6tqYoIRCKmPeY+/hxIO5vq4esnVMxP84E1LQZDJr2ZCLttuSDRRZuOcbG+fIV
         sOKyhlmGwH63ZFHaQdw0fX8+rpXrwxDy2BLKzpDu0DvjYwbsU7uLKMpXik5Ljm+Ytprz
         KgV4+u70sDv3CZX/iQx8QacO2p7A8sHpP0ruuAqHIJ0Lyj9Z7dbI9PGQewQ4jW72sCIV
         RQJZUVZQgKxNHvk78RRCvNeSJFF8FEIEfp2lNaEXMjApaefvga/tUokQoUjtU5FoVEzb
         +0Eg==
X-Gm-Message-State: APjAAAW0jQDKYVRVF7wz7+wLyZx2+qEXAxOf81AegUYabkB0ywA5YCQx
        ecd5cISMJUkKaFCtQOknbQQj/Sn9QX4=
X-Google-Smtp-Source: APXvYqzWx47H2mIWHIhzH0hFefOSJGdGV/xnAS6yVwwrlM3P2I0dbQxgk0/YFHAwyQiO8p0mEGBlIw==
X-Received: by 2002:a05:6602:220b:: with SMTP id n11mr53202058ion.6.1582560450510;
        Mon, 24 Feb 2020 08:07:30 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s12sm4493816iln.48.2020.02.24.08.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 08:07:30 -0800 (PST)
Subject: Re: [PATCH v4 2/2] test/splice: add basic splice tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582560081.git.asml.silence@gmail.com>
 <b4a11a08d6c6fe7c3292eac3d1eb9fb9f8f9d7dd.1582560081.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <10db22e1-cf67-464c-381b-f4ff25e91d26@kernel.dk>
Date:   Mon, 24 Feb 2020 09:07:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b4a11a08d6c6fe7c3292eac3d1eb9fb9f8f9d7dd.1582560081.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 9:03 AM, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Two things I'd like to see changed:

- Any error print should go to stderr, not stdout
- Should pass on kernels that don't have splice, the usual way there
  is to detect the -EINVAL and say that the test was skipped.

-- 
Jens Axboe

