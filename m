Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA05133089
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2020 21:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgAGU07 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jan 2020 15:26:59 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:37266 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgAGU07 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jan 2020 15:26:59 -0500
Received: by mail-io1-f47.google.com with SMTP id k24so748513ioc.4
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2020 12:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=id+gtDK+jZn375gdvQYfg0Nc3nJqlYiiO4nllbp+BqY=;
        b=Ku6ObxYzl9IPiU8uNHMpr2YNI//TrgrKir+S3czQCvYUd06cREwRfkNoXAsgxZET8L
         UES1Z6cw3n0tD5r0TIyDNUVAo6y83LbOaOF6jqoe0H4hEZBIAlRwt6C0kmMld0EzJ7GS
         8SExDFrZmbK6Xu1AZTmjv0yZOllZ+QHZ3bjcUlhUpbRZ1VU+upAPZ6va4x9ACC6G/+Bt
         o45arE7nwiIaWy+q0WvCO80hnJpPFWwKkilc2VKQw1LbXtNMurIeby2o5NNw45RMFTIU
         KnixTv0bqVVup4vLUgsikK8GjBlaIEQiJruweOkwJ4bsd20z00nJw8rW8gOHrusK+7/A
         iZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=id+gtDK+jZn375gdvQYfg0Nc3nJqlYiiO4nllbp+BqY=;
        b=K4T1BoOO7/ZkJxahoTm9ZmC1TFgBkRpX1X3/OVDpZNvT2FApicWq/CuYpBWCni7N84
         Y0DptSfIGup2OL3ehypHA3U78Av3bJNG28B5dWb15IJU+ofVUue8yQIbKjPGAlEl3rDo
         kolzrOzBI6mdsyFEkaIHr+h4/H3jbJdlMHcAhPXEHiBFkeY6l1wemODiElI1dWJw2HAY
         SONWDJi3Vhx8vqJ5lEERu/jnYJSSZUOawQ+I+/NJR7kshajUbE7ZNX2P6VQCkY5fwHlh
         AKr6zM5trs2D8tfVcjqRxVVwMiNTbM5akmrPFN7ySDNeDqcnKQ1UVByqWYzS4P1Qzi8M
         5MAw==
X-Gm-Message-State: APjAAAX1Cry0UnQoSlYjx7YGbRKIr0TbwPK+Q8jJtnno923g8pAQzfs9
        qmRVEZovKrcCMSOxTGBGOk781cC1WYw=
X-Google-Smtp-Source: APXvYqxBgP02/8SB5Xk+7svVLv9mR7BE/T8aZ2kd/YesPKWv2/wMRg4jmRsafCEKH/pGl3KVw1gOCA==
X-Received: by 2002:a6b:f206:: with SMTP id q6mr655868ioh.264.1578428818050;
        Tue, 07 Jan 2020 12:26:58 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i131sm120970iof.65.2020.01.07.12.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 12:26:57 -0800 (PST)
Subject: Re: io_uring and spurious wake-ups from eventfd
To:     Mark Papadakis <markuspapadakis@icloud.com>,
        io-uring@vger.kernel.org
References: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <55243723-480f-0220-2b93-74cc033c6e1d@kernel.dk>
Date:   Tue, 7 Jan 2020 13:26:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <2005CB9A-0883-4C35-B975-1931C3640AA1@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/7/20 8:55 AM, Mark Papadakis wrote:
> This is perhaps an odd request, but if it’s trivial to implement
> support for this described feature, it could help others like it ‘d
> help me (I ‘ve been experimenting with io_uring for some time now).
> 
> Being able to register an eventfd with an io_uring context is very
> handy, if you e.g have some sort of reactor thread multiplexing I/O
> using epoll etc, where you want to be notified when there are pending
> CQEs to drain. The problem, such as it is, is that this can result in
> un-necessary/spurious wake-ups.
> 
> If, for example, you are monitoring some sockets for EPOLLIN, and when
> poll says you have pending bytes to read from their sockets, and said
> sockets are non-blocking, and for each some reported event you reserve
> an SQE for preadv() to read that data and then you io_uring_enter to
> submit the SQEs, because the data is readily available, as soon as
> io_uring_enter returns, you will have your completions available -
> which you can process.  The “problem” is that poll will wake up
> immediately thereafter in the next reactor loop iteration because
> eventfd was tripped (which is reasonable but un-necessary).
> 
> What if there was a flag for io_uring_setup() so that the eventfd
> would only be tripped for CQEs that were processed asynchronously, or,
> if that’s non-trivial, only for CQEs that reference file FDs?
> 
> That’d help with that spurious wake-up.

One easy way to do that would be for the application to signal that it
doesn't want eventfd notifications for certain requests. Like using an
IOSQE_ flag for that. Then you could set that on the requests you submit
in response to triggering an eventfd event.

-- 
Jens Axboe

